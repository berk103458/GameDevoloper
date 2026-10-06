## Köy yönetimi (design/gdd/koy-yonetimi.md): ortak ambar, köylüler, yapılar, ızgara, ekonomi, moral,
## husumet, gece çözümü, aşamalar ve son. Sahne ve arayüzden bağımsız; tüm sayılar `KoyAyarlari`'ndan.
class_name KoyYonetimi
extends RefCounted

const KAYIT_SURUMU := 1
## Sonlar.
const SON_YOK := ""
const SON_HALK := "halk_kirildi"
const SON_ISYAN := "isyan"
const SON_TEKFUR := "tekfur"
const SON_ZAFER := "zafer"
## `Koylu.is_yeri` değerleri.
const BOSTA := -1
const MUHAFIZ := -2

var a: KoyAyarlari
var katalog: BinaKatalogu
var kaynaklar: Kaynaklar
var koylular: Array[Koylu] = []
var binalar: Array[KoyBinasi] = []
var izgara: Izgara
var husumet := Husumet.new()
var akce: int = 0
## Oyunun günü (0'dan).
var gun: int = 0
## Köy göstergeleri (0–100).
var adalet: int = 70
var asayis_riski: int = 10
## İsyan sayacı: -1 = isyan yok; yoksa kalan gün.
var isyan_kalan: int = -1
var en_yuksek_nufus: int = 0
var kabul_sayisi: int = 0
var ret_sayisi: int = 0
var agalik: bool = false
var sur_seviye: int = 0
var sur_taksit_odenen: int = 0
## Bu hafta vergi alınmayacak (isyan çıkışı).
var vergi_muaf: bool = false
## Tekfur: haraç bekliyor mu, kaç baskı savuşturuldu, baskı gücü.
var harac_bekliyor: bool = false
var tekfur_baski: int = 0
var savusturulan: int = 0
var son: String = SON_YOK

var _sonraki_id: int = 1
## Ondalık üretim artıkları: "binaId:tür" → kesir.
var _artik: Dictionary = {}
var _tezgah_bugun: int = 0
var _bugun_zengin_kabul: bool = false
var _bugun_usta_ret: bool = false
var _rng: RandomNumberGenerator


func _init(ayarlar: KoyAyarlari, katalog_: BinaKatalogu, tohum: int = 1) -> void:
	a = ayarlar
	katalog = katalog_
	kaynaklar = Kaynaklar.new(a.ambar_taban_kapasite, a.baslangic_kaynak)
	izgara = Izgara.new(a.izgara_boyut, a.meydan)
	akce = a.akce_baslangic
	_rng = RandomNumberGenerator.new()
	_rng.seed = tohum


# ── Sorgular ──────────────────────────────────────────────────────────────────────────────────────

func nufus() -> int:
	return koylular.size()


func mevsim() -> int:
	return Takvim.mevsim(gun, a.mevsim_gun)


func kis_mi() -> bool:
	return Takvim.kis_mi(gun, a.mevsim_gun)


func koylu(id: int) -> Koylu:
	for k in koylular:
		if k.id == id:
			return k
	return null


func bina(id: int) -> KoyBinasi:
	for b in binalar:
		if b.id == id:
			return b
	return null


## Bir yapıda çalışanlar.
func calisanlar(bina_id: int) -> Array[Koylu]:
	var s: Array[Koylu] = []
	for k in koylular:
		if k.is_yeri == bina_id:
			s.append(k)
	return s


func muhafiz_sayisi() -> int:
	var n := 0
	for k in koylular:
		if k.is_yeri == MUHAFIZ:
			n += 1
	return n


func bostakiler() -> Array[Koylu]:
	var s: Array[Koylu] = []
	for k in koylular:
		if k.is_yeri == BOSTA:
			s.append(k)
	return s


func yatak_kapasitesi() -> int:
	var n := 0
	for b in binalar:
		if b.hazir():
			n += katalog.yatak(b.tur)
	return n


## Köy huzuru: moral ortalaması (köy boşsa 100).
func huzur() -> int:
	if koylular.is_empty():
		return 100
	var t := 0
	for k in koylular:
		t += k.moral
	return t / koylular.size()


## Emniyet kilidi açıldı mı (16.1): köy en az bir kez `emniyet_nufus`a ulaşmış VE `emniyet_gun` geçmiş.
func emniyet_acik() -> bool:
	return en_yuksek_nufus >= a.emniyet_nufus and gun >= a.emniyet_gun


func kervan_gunu() -> bool:
	return gun % a.kervan_araligi == a.kervan_araligi - 1


## Ambarda kaç günlük gıda var (uyarı için).
func gida_gunu() -> float:
	return float(kaynaklar.miktar("gida")) / float(maxi(1, nufus() * a.gida_kisi))


# ── Kapı: kabul ve ret ────────────────────────────────────────────────────────────────────────────

## Kapıdan biri içeri alınır; serbest iş gücü havuzuna (boşta) yazılır. `v`: {ad, adli_id, sinif, portre, stat,
## bayraklar, gizli}. `harc`: yoksuldan zorla geçiş akçesi kesildi; `rusvet`: şüpheli rüşvetle alındı (akçe ayrıca
## verilir); `zengin`: parası için alındı.
func kabul(v: Dictionary, harc: bool = false, rusvet: int = 0, zengin: bool = false, rusvet_koy_kasasina: bool = true) -> Koylu:
	var k := Koylu.new()
	k.id = _sonraki_id
	_sonraki_id += 1
	k.ad = String(v.get("ad", ""))
	k.adli_id = StringName(v.get("adli_id", ""))
	k.sinif = StringName(v.get("sinif", "ciftci"))
	k.portre = String(v.get("portre", ""))
	k.stat = clampi(int(v.get("stat", 5)), 1, 10)
	k.bayraklar = PackedStringArray(v.get("bayraklar", []))
	k.gizli_bayraklar = PackedStringArray(v.get("gizli", []))
	k.moral = a.baslangic_moral
	k.sadakat = a.baslangic_sadakat
	k.giris_gunu = gun
	if harc:
		akce += a.harc_akce
		k.bayrak_ekle("somurulmus")
		k.sadakat = int(k.sadakat * (1.0 - a.harc_sadakat_orani))
		adalet = maxi(0, adalet - a.harc_adalet)
	if rusvet > 0:
		if rusvet_koy_kasasina:
			akce += rusvet
		asayis_riski = mini(100, asayis_riski + a.rusvet_asayis)
	if zengin:
		_bugun_zengin_kabul = true
	koylular.append(k)
	kabul_sayisi += 1
	en_yuksek_nufus = maxi(en_yuksek_nufus, nufus())
	return k


## Kapıdan biri geri çevrilir. `haksiz`: masum köylü ya da usta (kanıtsız ret); `usta_uzmanlik`: ustaysa uzmanlığı.
func ret(ad: String, haksiz: bool, usta_uzmanlik: String = "") -> void:
	husumet.ret(ad, gun, haksiz, usta_uzmanlik, a)
	ret_sayisi += 1
	if haksiz and usta_uzmanlik != "":
		_bugun_usta_ret = true


# ── Yapılar ve yollar ─────────────────────────────────────────────────────────────────────────────

## Yerleşim önizlemesi (hayalet): {olur, neden, maliyet}. Neden: `sinir`, `dolu`, `yol_yok`, `malzeme`, `akce`.
func yerlesim(tur: String, hucre: Vector2i, yon: int = 0) -> Dictionary:
	var b := KoyBinasi.new()
	b.tur = tur
	b.hucre = hucre
	b.yon = yon
	var m := katalog.maliyet(tur)
	var d := izgara.yerlesebilir(b.hucreler(katalog))
	d["maliyet"] = m
	if d["olur"] and not kaynaklar.yeterli(_malzeme(m)):
		d["olur"] = false
		d["neden"] = "malzeme"
	if d["olur"] and akce < int(m.get("akce", 0)):
		d["olur"] = false
		d["neden"] = "akce"
	return d


## Yapı kurar (iskele): malzeme düşer, inşa süresi başlar. Döner: {olur, neden, id}.
func bina_kur(tur: String, hucre: Vector2i, yon: int = 0) -> Dictionary:
	if not katalog.var_mi(tur):
		return {"olur": false, "neden": "tur", "id": -1}
	if not katalog.veri(tur).get("kurulabilir", true):
		return {"olur": false, "neden": "hedef_turu", "id": -1}
	var d := yerlesim(tur, hucre, yon)
	if not d["olur"]:
		d["id"] = -1
		return d
	var m := katalog.maliyet(tur)
	kaynaklar.harca(_malzeme(m))
	akce -= int(m.get("akce", 0))
	var b := KoyBinasi.new()
	b.id = _sonraki_id
	_sonraki_id += 1
	b.tur = tur
	b.hucre = hucre
	b.yon = yon
	b.insa_kalan = int(katalog.veri(tur).get("insa_gun", 1))
	b.harcanan = m.duplicate()
	var r := katalog.receteler(tur)
	if not r.is_empty():
		b.recete = String(r.keys()[0])
	binalar.append(b)
	izgara.yerlestir(b.id, b.hucreler(katalog))
	return {"olur": true, "neden": "", "id": b.id}


## Yapıyı yıkar: harcanan malzemenin yarısı ambara döner; çalışanlar boşa, oturanlar evsiz kalır.
func bina_yik(id: int) -> bool:
	var b := bina(id)
	if b == null:
		return false
	for t in b.harcanan:
		if t == "akce":
			akce += int(int(b.harcanan[t]) * a.yikim_iade)
		else:
			kaynaklar.ekle(t, int(int(b.harcanan[t]) * a.yikim_iade))
	for k in koylular:
		if k.is_yeri == id:
			k.is_yeri = BOSTA
		if k.ev == id:
			k.ev = -1
	izgara.kaldir(id)
	binalar.erase(b)
	_ambar_kapasitesi()
	return true


func yol_kur(h: Vector2i) -> bool:
	return izgara.yol_kur(h)


## Çok amaçlı yapıda üretilecek reçete.
func recete_sec(bina_id: int, recete: String) -> bool:
	var b := bina(bina_id)
	if b == null or not katalog.receteler(b.tur).has(recete):
		return false
	b.recete = recete
	return true


# ── İş atama ──────────────────────────────────────────────────────────────────────────────────────

## Köylüyü bir yapının iş yuvasına atar (yapı hazır ve yuva boş olmalı).
func ata(koylu_id: int, bina_id: int) -> bool:
	var k := koylu(koylu_id)
	var b := bina(bina_id)
	if k == null or b == null or not b.hazir() or katalog.slot(b.tur) == 0:
		return false
	if calisanlar(bina_id).size() >= katalog.slot(b.tur) and k.is_yeri != bina_id:
		return false
	k.is_yeri = bina_id
	return true


## Köylüyü muhafız yapar (en çok `muhafiz_azami`).
func muhafiz_ata(koylu_id: int) -> bool:
	var k := koylu(koylu_id)
	if k == null or (k.is_yeri != MUHAFIZ and muhafiz_sayisi() >= a.muhafiz_azami):
		return false
	k.is_yeri = MUHAFIZ
	return true


func bosalt(koylu_id: int) -> void:
	var k := koylu(koylu_id)
	if k != null:
		k.is_yeri = BOSTA


## Köylüyü köyden sürer (10.5, 12.4). Tekrar gelirse husumet gerekçeli rettir.
func surgun(koylu_id: int) -> bool:
	var k := koylu(koylu_id)
	if k == null:
		return false
	koylular.erase(k)
	husumet.ret(k.ad, gun, false, "", a)
	return true


# ── Ticaret ───────────────────────────────────────────────────────────────────────────────────────

## Köy tezgâhında anında satış (5.1): kervan fiyatının `tezgah_orani`'ndan, günde en çok `tezgah_gunluk_azami` akçe.
## Döner: {satilan, akce}. Yalnız tam akçeye denk gelen kadar satılır.
func tezgah_sat(tur: String, adet: int) -> Dictionary:
	var fiyat := float(a.kervan_fiyat.get(tur, 0.0)) * a.tezgah_orani
	if fiyat <= 0.0:
		return {"satilan": 0, "akce": 0}
	var kalan := a.tezgah_gunluk_azami - _tezgah_bugun
	var adet_ := mini(adet, kaynaklar.miktar(tur))
	var kazanc := mini(int(adet_ * fiyat), kalan)
	if kazanc <= 0:
		return {"satilan": 0, "akce": 0}
	var satilan := mini(adet_, ceili(kazanc / fiyat))
	kaynaklar.azalt(tur, satilan)
	akce += kazanc
	_tezgah_bugun += kazanc
	return {"satilan": satilan, "akce": kazanc}


## Kervana tam fiyatla satış (5.2; yalnız kervan günü).
func kervana_sat(tur: String, adet: int) -> Dictionary:
	if not kervan_gunu():
		return {"satilan": 0, "akce": 0}
	var fiyat := float(a.kervan_fiyat.get(tur, 0.0))
	var adet_ := mini(adet, kaynaklar.miktar(tur))
	var kazanc := int(adet_ * fiyat)
	if kazanc <= 0:
		return {"satilan": 0, "akce": 0}
	var satilan := mini(adet_, ceili(kazanc / fiyat))
	kaynaklar.azalt(tur, satilan)
	akce += kazanc
	return {"satilan": satilan, "akce": kazanc}


## Kervandan alış (demir, alet, kışlık tahıl). Tekfur'a geçen bir usta varsa o mal daha pahalıdır (3.5).
func kervandan_al(tur: String, adet: int) -> bool:
	if not kervan_gunu() or not a.kervan_satis.has(tur):
		return false
	var fiyat := float(a.kervan_satis[tur])
	if tur == "alet" and "demirci" in husumet.tekfura_gecenler:
		fiyat *= 1.5
	var bedel := ceili(fiyat * adet)
	if akce < bedel or kaynaklar.bos_yer() < adet:
		return false
	akce -= bedel
	kaynaklar.ekle(tur, adet)
	return true


## Savunma ve lüks harcamaları son `rezerv` akçeye dokunamaz (5.4).
func kilitli_harcanabilir(miktar: int) -> bool:
	return akce - miktar >= a.rezerv


## Sur taksiti (5.5): seviyenin bedeli `sur_taksit` parçada ödenir; son taksitle sur bir seviye yükselir.
func sur_taksiti() -> int:
	if sur_seviye >= a.sur_bedel.size():
		return -1
	return ceili(float(a.sur_bedel[sur_seviye]) / a.sur_taksit)


func sur_taksit_ode() -> bool:
	var t := sur_taksiti()
	if t < 0 or not kilitli_harcanabilir(t):
		return false
	akce -= t
	sur_taksit_odenen += 1
	if sur_taksit_odenen >= a.sur_taksit:
		sur_taksit_odenen = 0
		sur_seviye += 1
	return true


# ── İsyan çıkış eylemleri (11.4) ──────────────────────────────────────────────────────────────────

func as_dagit() -> bool:
	var gerek := nufus() * a.as_dagit_gida
	if kaynaklar.miktar("gida") < gerek:
		return false
	kaynaklar.azalt("gida", gerek)
	_herkese_moral(a.as_dagit_moral)
	return true


func vergi_sifirla() -> void:
	if vergi_muaf:
		return
	vergi_muaf = true
	_herkese_moral(a.vergi_sifirla_moral)


## En huzursuz köylüyü (elebaşı) sürer; geride kalanların morali yükselir.
func elebasi_surgun() -> bool:
	if koylular.is_empty():
		return false
	var en: Koylu = koylular[0]
	for k in koylular:
		if k.moral < en.moral:
			en = k
	surgun(en.id)
	_herkese_moral(a.surgun_moral)
	return true


# ── Tekfur ────────────────────────────────────────────────────────────────────────────────────────

func harac_ode() -> bool:
	if not harac_bekliyor or akce < a.harac_akce or kaynaklar.miktar("gida") < a.harac_gida:
		return false
	akce -= a.harac_akce
	kaynaklar.azalt("gida", a.harac_gida)
	harac_bekliyor = false
	return true


func harac_reddet() -> void:
	if harac_bekliyor:
		harac_bekliyor = false
		tekfur_baski += 1


func savunma_gucu() -> int:
	var asker := 0
	for k in koylular:
		if k.sinif == &"asker":
			asker += 1
	return sur_seviye * 2 + muhafiz_sayisi() + asker / 2


func tekfur_gucu() -> int:
	return 2 + tekfur_baski * 2


# ── Gece (Faz 3) ──────────────────────────────────────────────────────────────────────────────────

## Günü kapatır: üretim, inşaat, tüketim, sağlık ve moral, akçe, husumet, asayiş, isyan, aşamalar, son.
## Döner: rapor {gun, uretim, tuketim, akce_once, akce, olaylar: [{anahtar, deger}], olenler, huzur, son}.
func gece() -> Dictionary:
	var olaylar: Array[Dictionary] = []
	var rapor := {"gun": gun, "uretim": {}, "tuketim": {}, "akce_once": akce, "olaylar": olaylar, "olenler": []}
	_iltimas_denetimi(olaylar)
	if kis_mi():
		_kis_kaydirmasi()
	else:
		_bahar_donusu()
	if isyan_kalan < 0:
		_uret(rapor["uretim"], olaylar)
	else:
		olaylar.append({"anahtar": "koy.olay.isyan_uretim_yok"})
	_insaat()
	_barindir()
	_tuket(rapor["tuketim"], olaylar)
	_saglik_ve_moral(rapor["olenler"], olaylar)
	_akce(olaylar)
	_husumet(olaylar)
	asayis_riski = maxi(0, asayis_riski - a.asayis_sonum - muhafiz_sayisi() * a.muhafiz_asayis)
	_isyan(olaylar)
	_asamalar(olaylar)
	_son_denetimi()
	rapor["akce"] = akce
	rapor["huzur"] = huzur()
	rapor["son"] = son
	gun += 1
	_tezgah_bugun = 0
	_bugun_zengin_kabul = false
	_bugun_usta_ret = false
	if Takvim.hafta_basi(gun, a.mevsim_gun):
		vergi_muaf = false
	return rapor


func _iltimas_denetimi(olaylar: Array[Dictionary]) -> void:
	# Zengin alınıp usta dışarıda bırakıldıysa: "Muhafız zengine çalışıyor" (2.5).
	if _bugun_zengin_kabul and _bugun_usta_ret:
		_herkese_moral(-a.iltimas_moral)
		olaylar.append({"anahtar": "koy.olay.iltimas", "deger": [a.iltimas_moral]})


func _kis_kaydirmasi() -> void:
	# Kışın tarlalar donar: çiftçiler kışın da çalışan bir yapıya (boş yuva) ya da inşaata geçer (8.5).
	for k in koylular:
		var b := bina(k.is_yeri)
		if b == null or not bool(katalog.veri(b.tur).get("kis_durur", false)):
			continue
		k.kis_oncesi_is = k.is_yeri
		k.is_yeri = BOSTA
		for h in binalar:
			if h.hazir() and katalog.slot(h.tur) > calisanlar(h.id).size() and not bool(katalog.veri(h.tur).get("kis_durur", false)):
				k.is_yeri = h.id
				break


## Kış bitti: kaydırılanlar eski yapılarına döner (yapı duruyorsa ve yuva boşsa).
func _bahar_donusu() -> void:
	for k in koylular:
		if k.kis_oncesi_is < 0:
			continue
		var eski := k.kis_oncesi_is
		k.kis_oncesi_is = -1
		var b := bina(eski)
		if b != null and calisanlar(eski).size() < katalog.slot(b.tur):
			k.is_yeri = eski


func _uret(uretim: Dictionary, olaylar: Array[Dictionary]) -> void:
	for b in binalar:
		b.bekliyor = ""
		if not b.hazir() or b.recete == "":
			continue
		if kis_mi() and bool(katalog.veri(b.tur).get("kis_durur", false)):
			b.bekliyor = "kis"
			continue
		var r: Dictionary = katalog.receteler(b.tur).get(b.recete, {})
		var girdi: Dictionary = r.get("girdi", {})
		var cikti: Dictionary = r.get("uretim", {})
		var uzmanlik := String(katalog.veri(b.tur).get("uzmanlik", ""))
		for k in calisanlar(b.id):
			if not girdi.is_empty() and not kaynaklar.harca(girdi):
				b.bekliyor = "girdi"
				break
			var c := Uretim.bilesik_carpan(k.bayraklar + k.gizli_bayraklar, uzmanlik, a.flag_carpanlari, a.carpan_alt, a.carpan_ust)
			if k.ac:
				c *= a.aclik_verim
			var bonus := a.kritik_bonus if k.moral > a.kritik_moral else 0.0
			for t in cikti:
				var miktar := Uretim.gunluk(float(cikti[t]), k.stat, c)
				_ambara(b, t, miktar, miktar * bonus, uretim, olaylar)


## Üretimi ambara yazar; ambar doluysa üretim durur, kritik bonus ise tezgâh fiyatından akçeye döner (11.5).
func _ambara(b: KoyBinasi, tur: String, miktar: float, bonus: float, uretim: Dictionary, olaylar: Array[Dictionary]) -> void:
	var anahtar := "%d:%s" % [b.id, tur]
	var toplam := float(_artik.get(anahtar, 0.0)) + miktar
	var tam := int(toplam)
	_artik[anahtar] = toplam - tam
	var giren := kaynaklar.ekle(tur, tam)
	uretim[tur] = int(uretim.get(tur, 0)) + giren
	if giren < tam:
		b.bekliyor = "ambar_dolu"
	if bonus > 0.0:
		var bonus_tam := int(round(bonus))
		var bonus_giren := kaynaklar.ekle(tur, bonus_tam)
		uretim[tur] = int(uretim.get(tur, 0)) + bonus_giren
		var tasan := bonus_tam - bonus_giren
		if tasan > 0:
			var para := int(tasan * float(a.kervan_fiyat.get(tur, 0.0)) * a.tezgah_orani)
			if para > 0:
				akce += para
				olaylar.append({"anahtar": "koy.olay.bonus_satis", "deger": [tasan, para]})


func _insaat() -> void:
	var yardim := bostakiler().size() / maxi(1, a.insa_yardim_bolen)
	for b in binalar:
		if b.insa_kalan > 0:
			b.insa_kalan = maxi(0, b.insa_kalan - 1 - yardim)
	_ambar_kapasitesi()


func _ambar_kapasitesi() -> void:
	var k := a.ambar_taban_kapasite
	for b in binalar:
		if b.hazir():
			k += int(katalog.veri(b.tur).get("kapasite", 0))
	kaynaklar.kapasite = k


## Evsizleri boş yataklara yerleştirir (9.3).
func _barindir() -> void:
	var dolu := {}
	for k in koylular:
		if k.ev >= 0 and bina(k.ev) != null:
			dolu[k.ev] = int(dolu.get(k.ev, 0)) + 1
		else:
			k.ev = -1
	for k in koylular:
		if k.ev >= 0:
			continue
		for b in binalar:
			if b.hazir() and katalog.yatak(b.tur) > int(dolu.get(b.id, 0)):
				k.ev = b.id
				dolu[b.id] = int(dolu.get(b.id, 0)) + 1
				break


func _hane_sayisi() -> int:
	var haneler := {}
	var evsiz := false
	for k in koylular:
		if k.ev >= 0:
			haneler[k.ev] = true
		else:
			evsiz = true
	return haneler.size() + (1 if evsiz else 0)


func _tuket(tuketim: Dictionary, olaylar: Array[Dictionary]) -> void:
	var gerek := nufus() * a.gida_kisi
	var yenen := kaynaklar.azalt("gida", gerek)
	tuketim["gida"] = yenen
	var ac_sayisi := 0
	if yenen < gerek:
		ac_sayisi = int(ceil(float(gerek - yenen) / a.gida_kisi))
		olaylar.append({"anahtar": "koy.olay.aclik", "deger": [ac_sayisi]})
	# Açlık önce en son gelenlere düşer (en eski köylüler payını önce alır).
	for i in koylular.size():
		koylular[i].ac = i >= koylular.size() - ac_sayisi
	if kis_mi():
		var odun := _hane_sayisi() * a.kis_odun_hane
		var yakilan := kaynaklar.azalt("odun", odun)
		tuketim["odun"] = yakilan
		if yakilan < odun:
			for k in koylular:
				k.saglik -= a.soguk_saglik
			olaylar.append({"anahtar": "koy.olay.soguk", "deger": [a.soguk_saglik]})


func _saglik_ve_moral(olenler: Array, olaylar: Array[Dictionary]) -> void:
	var guvensiz := asayis_riski > a.asayis_moral_esigi
	var adaletsiz := adalet < a.adalet_moral_esigi
	for k in koylular:
		if k.ac:
			k.saglik -= a.aclik_saglik
			k.moral -= a.aclik_moral
		else:
			k.moral += a.tok_moral
			if k.ev >= 0:
				k.saglik += a.iyilesme
		if k.ev < 0:
			k.moral -= a.evsiz_moral
		if guvensiz:
			k.moral -= a.guvensiz_moral
		if adaletsiz:
			k.moral -= a.adaletsiz_moral
		k.saglik = clampi(k.saglik, 0, 100)
		k.moral = clampi(k.moral, 0, 100)
	for k in koylular.duplicate():
		if k.saglik <= 0:
			koylular.erase(k)
			olenler.append(k.ad)
			olaylar.append({"anahtar": "koy.olay.olum", "deger": [k.ad]})


func _akce(olaylar: Array[Dictionary]) -> void:
	var maas := muhafiz_sayisi() * a.muhafiz_maas
	if maas > 0:
		if akce >= maas:
			akce -= maas
		else:
			# Ödenmeyen muhafız görevi bırakır.
			for k in koylular:
				if k.is_yeri == MUHAFIZ:
					k.is_yeri = BOSTA
					k.moral = maxi(0, k.moral - 10)
			olaylar.append({"anahtar": "koy.olay.maas_yok"})
	if Takvim.hafta_basi(gun + 1, a.mevsim_gun) and not vergi_muaf:
		var vergi := 0
		for k in koylular:
			vergi += a.vergi_usta if k.usta_mi() else a.vergi_isci
		akce += vergi
		olaylar.append({"anahtar": "koy.olay.vergi", "deger": [vergi]})


func _husumet(olaylar: Array[Dictionary]) -> void:
	match husumet.gece(a, muhafiz_sayisi(), _rng):
		"sizma":
			var g := kaynaklar.azalt("gida", maxi(3, kaynaklar.miktar("gida") / 6))
			var al := kaynaklar.azalt("alet", 1)
			olaylar.append({"anahtar": "koy.olay.sizma", "deger": [g, al]})
		"baskin":
			var g := kaynaklar.azalt("gida", kaynaklar.miktar("gida") * 3 / 10)
			var o := kaynaklar.azalt("odun", kaynaklar.miktar("odun") / 5)
			for i in mini(2, koylular.size()):
				var k: Koylu = koylular[_rng.randi_range(0, koylular.size() - 1)]
				k.saglik = maxi(1, k.saglik - 40)
			_herkese_moral(-15)
			asayis_riski = mini(100, asayis_riski + 20)
			olaylar.append({"anahtar": "koy.olay.baskin", "deger": [g, o]})


func _isyan(olaylar: Array[Dictionary]) -> void:
	if koylular.is_empty():
		return
	if isyan_kalan < 0:
		if huzur() <= a.isyan_esigi:
			isyan_kalan = a.isyan_gun
			olaylar.append({"anahtar": "koy.olay.isyan_basladi", "deger": [a.isyan_gun]})
		return
	if huzur() > a.isyan_esigi:
		isyan_kalan = -1
		olaylar.append({"anahtar": "koy.olay.isyan_bitti"})
		return
	# İsyan sürüyor: bir köylü ambardan erzak çalıp kaçar.
	var k: Koylu = koylular[_rng.randi_range(0, koylular.size() - 1)]
	var calinan := kaynaklar.azalt("gida", 5)
	koylular.erase(k)
	olaylar.append({"anahtar": "koy.olay.firar", "deger": [k.ad, calinan]})
	isyan_kalan -= 1
	if isyan_kalan <= 0:
		son = SON_ISYAN


func _asamalar(olaylar: Array[Dictionary]) -> void:
	if not agalik and nufus() >= a.agalik_nufus:
		agalik = true
		olaylar.append({"anahtar": "koy.olay.agalik"})
	if not agalik:
		return
	# Cevapsız haraç reddedilmiş sayılır; reddedilen haraç Tekfur baskınıyla döner.
	if harac_bekliyor:
		harac_reddet()
		olaylar.append({"anahtar": "koy.olay.harac_cevapsiz"})
	if tekfur_baski > savusturulan:
		var guc := tekfur_gucu()
		var savunma := savunma_gucu()
		olaylar.append({"anahtar": "koy.olay.tekfur_baskini", "deger": [guc, savunma]})
		if guc > savunma:
			son = SON_TEKFUR
			return
		savusturulan += 1
		if savusturulan >= a.zafer_bask_sayisi:
			son = SON_ZAFER
			return
	if (gun + 1) % a.harac_araligi == 0:
		harac_bekliyor = true
		olaylar.append({"anahtar": "koy.olay.harac", "deger": [a.harac_akce, a.harac_gida]})


func _son_denetimi() -> void:
	if son != SON_YOK:
		return
	if emniyet_acik() and nufus() < a.kirilma_nufus:
		son = SON_HALK


func _herkese_moral(miktar: int) -> void:
	for k in koylular:
		k.moral = clampi(k.moral + miktar, 0, 100)


func _malzeme(maliyet: Dictionary) -> Dictionary:
	var m := maliyet.duplicate()
	m.erase("akce")
	return m


# ── Kayıt ─────────────────────────────────────────────────────────────────────────────────────────

func kaydet() -> Dictionary:
	var k: Array = []
	for x in koylular:
		k.append(x.kaydet())
	var b: Array = []
	for x in binalar:
		b.append(x.kaydet())
	return {"surum": KAYIT_SURUMU, "kaynaklar": kaynaklar.kaydet(), "koylular": k, "binalar": b, "izgara": izgara.kaydet(),
		"husumet": husumet.kaydet(), "akce": akce, "gun": gun, "adalet": adalet, "asayis": asayis_riski,
		"isyan": isyan_kalan, "en_yuksek": en_yuksek_nufus, "kabul": kabul_sayisi, "ret": ret_sayisi, "agalik": agalik,
		"sur": sur_seviye, "sur_taksit": sur_taksit_odenen, "vergi_muaf": vergi_muaf, "harac": harac_bekliyor,
		"tekfur": tekfur_baski, "savusturulan": savusturulan, "son": son, "sonraki_id": _sonraki_id, "artik": _artik.duplicate(),
		"tezgah": _tezgah_bugun, "rng": _rng.state}


static func kayittan(ayarlar: KoyAyarlari, katalog_: BinaKatalogu, v: Dictionary) -> KoyYonetimi:
	var y := KoyYonetimi.new(ayarlar, katalog_)
	y.kaynaklar = Kaynaklar.kayittan(v.get("kaynaklar", {}))
	for x in v.get("koylular", []):
		y.koylular.append(Koylu.kayittan(x))
	for x in v.get("binalar", []):
		var b := KoyBinasi.kayittan(x)
		y.binalar.append(b)
		y.izgara.yerlestir(b.id, b.hucreler(katalog_))
	y.izgara.kayittan_yukle(v.get("izgara", {}))
	y.husumet = Husumet.kayittan(v.get("husumet", {}))
	y.akce = int(v.get("akce", 0))
	y.gun = int(v.get("gun", 0))
	y.adalet = int(v.get("adalet", 70))
	y.asayis_riski = int(v.get("asayis", 10))
	y.isyan_kalan = int(v.get("isyan", -1))
	y.en_yuksek_nufus = int(v.get("en_yuksek", 0))
	y.kabul_sayisi = int(v.get("kabul", 0))
	y.ret_sayisi = int(v.get("ret", 0))
	y.agalik = bool(v.get("agalik", false))
	y.sur_seviye = int(v.get("sur", 0))
	y.sur_taksit_odenen = int(v.get("sur_taksit", 0))
	y.vergi_muaf = bool(v.get("vergi_muaf", false))
	y.harac_bekliyor = bool(v.get("harac", false))
	y.tekfur_baski = int(v.get("tekfur", 0))
	y.savusturulan = int(v.get("savusturulan", 0))
	y.son = String(v.get("son", ""))
	y._sonraki_id = int(v.get("sonraki_id", 1))
	y._artik = v.get("artik", {})
	y._tezgah_bugun = int(v.get("tezgah", 0))
	if v.has("rng"):
		y._rng.state = int(v["rng"])
	y._ambar_kapasitesi()
	return y
