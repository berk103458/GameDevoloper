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
var lojistik := CekiLojistigi.new()
var gezgin_ticaret := GezginTuccarStogu.new()
var siparisler := SiparisSozlesmeleri.new()
var tuccar_itibari: Dictionary = {}
var tuccar_cezasi: Dictionary = {}
var tuccar_girisi: Dictionary = {}
var kervan_koruma: Dictionary = {}
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
## Hasar yalnız sura aittir: 0 sağlam, 50 hasarlı, 100 yanmış/işlevsiz.
var sur_hasar: int = 0:
	set(v):
		sur_hasar = clampi(v, 0, 100)
var sur_taksit_odenen: int = 0
## Kesirli alet aşınması; yalnız gerçek üretimden, optional JSON alanı.
var alet_asinma: float = 0.0
## Optional kişi bazlı kamu maaşı borcu ve gizli rüşvet ledgerı.
var maas_durumu: Dictionary = {}
## Bu hafta vergi alınmayacak (isyan çıkışı).
var vergi_muaf: bool = false
## Eski kayıtlar orta vergiyle başlar; tahsilat tarihi tekrar ödemeyi önler.
var vergi_orani: String = "orta"
var son_vergi_gece: int = -1
## EKO-10: doğrulanmış optional kamu açığı geçmişi.
var iflas_durumu: Dictionary = IflasYoneticisi.oku({})
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
	return IklimDeneyi.mevsim(self, Takvim.mevsim(gun, a.mevsim_gun))


func kis_mi() -> bool:
	return mevsim() == 3 or IklimDeneyi.hava(self) == "kar_firtinasi"


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
		if MuhafizMaasi.aday(k, self):
			n += 1
	return n


func etkin_muhafiz_sayisi() -> int:
	var n := 0
	for k in koylular:
		if not KervanKorumasi.disarida(self, k.id) and MuhafizMaasi.aday(k, self) and not MuhafizMaasi.borclu(k, self) and k.yas_grubu == &"yetiskin" and not IsKazalari.uyuyor(k) and not IsMemnuniyeti.isyanci(k, self): n += 1
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
			n += b.yatak(katalog)
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


## Mevcut ticaret API'si: uzman tüccarın iki günlük konaklama aralığı.
func kervan_gunu() -> bool:
	var d := GezginTuccarTakvimi.durum(gun, a.kervan_araligi)
	return d.aktif and not SiparisIhlali.terk(self, d.tuccar.id) and not TuccarKapiGecisi.engel(self)


## Ambarda kaç günlük gıda var (uyarı için).
func gida_gunu() -> float:
	return float(kaynaklar.miktar("gida")) / float(maxi(1, int(TuketimDengesi.gerek(self).gida)))


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
	k.zanaat_turu = ZanaatTuru.oku(v.get("zanaat_turu"), ZanaatTuru.coz(k.adli_id, k.sinif))
	k.pasif_ozellikler = PasifOzellikler.oku(v.get("pasif_ozellikler"), PasifOzellikler.cift(k.adli_id, k.sinif, k.id))
	k.toplumsal_bag = KanDavasi.oku(v.get("toplumsal_bag"), KanDavasi.kaynak(k.adli_id))
	k.yas_grubu = YasRolleri.oku(v.get("yas_grubu"), k.adli_id)
	k.portre = String(v.get("portre", ""))
	k.stat = clampi(int(v.get("stat", 5)), 1, 10)
	k.bayraklar = PackedStringArray(v.get("bayraklar", []))
	k.gizli_bayraklar = PackedStringArray(v.get("gizli", []))
	k.gizli_egilim = GizliEgilimler.oku(v.get("gizli_egilim"), k)
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
	return _bina_cikar(id, true)

## EKO-10: kamu malını iadesiz çıkarır; çalışan/barınak/ızgara temizliği yıkımla ortaktır.
func bina_el_koy(id: int) -> bool:
	return _bina_cikar(id, false)

func _bina_cikar(id: int, iade: bool) -> bool:
	var b := bina(id)
	if b == null:
		return false
	if iade:
		for t in b.harcanan:
			if t == "akce":
				akce += int(int(b.harcanan[t]) * a.yikim_iade)
			else:
				kaynaklar.ekle(t, int(int(b.harcanan[t]) * a.yikim_iade))
	for k in koylular:
		if k.is_yeri == id:
			k.is_yeri = BOSTA
		if k.kis_oncesi_is == id: k.kis_oncesi_is = -1
		if k.ev == id:
			k.ev = -1
	for anahtar in _artik.keys():
		if String(anahtar).begins_with(str(id) + ":"): _artik.erase(anahtar)
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
	if KervanKorumasi.disarida(self, koylu_id): return false
	var k := koylu(koylu_id)
	var b := bina(bina_id)
	if k == null or b == null or not b.hazir() or katalog.slot(b.tur) == 0:
		return false
	if not YasRolleri.atanabilir(k, b.tur): return false
	if b.tur == "muhafiz_kislasi" and (k.yas_grubu != &"yetiskin" or (not MuhafizMaasi.aday(k, self) and muhafiz_sayisi() >= a.muhafiz_azami)): return false
	if calisanlar(bina_id).size() >= katalog.slot(b.tur) and k.is_yeri != bina_id:
		return false
	k.is_yeri = bina_id
	return true


## Köylüyü muhafız yapar (en çok `muhafiz_azami`).
func muhafiz_ata(koylu_id: int) -> bool:
	if KervanKorumasi.disarida(self, koylu_id): return false
	var k := koylu(koylu_id)
	if DivanHukmu.zindanda(k): return false
	if k != null and k.yas_grubu != &"yetiskin": return false
	if k == null or (not MuhafizMaasi.aday(k, self) and muhafiz_sayisi() >= a.muhafiz_azami):
		return false
	k.is_yeri = MUHAFIZ
	return true


func bosalt(koylu_id: int) -> void:
	if KervanKorumasi.disarida(self, koylu_id): return
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
	var fiyat := TicaretFiyatlari.sat_birim(self, tur) * a.tezgah_orani
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
	var fiyat := TicaretFiyatlari.sat_birim(self, tur)
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
	if GezginTuccarStogu.urunler(self).has(tur): return gezgin_ticaret.al(self, tur, adet)
	if not kervan_gunu() or not a.kervan_satis.has(tur):
		return false
	if adet <= 0: return false
	var bedel := TicaretFiyatlari.bedel(self, tur, adet)
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
	if not kaynaklar.harca(HarcZinciri.sur_malzeme(self)):
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
		if k.sinif == &"asker" and k.yas_grubu == &"yetiskin" and not IsKazalari.uyuyor(k) and not IsMemnuniyeti.isyanci(k, self):
			asker += 1
	return BinaSeviyesi.sur_gucu(sur_seviye, sur_hasar) + etkin_muhafiz_sayisi() + asker / 2


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
	rapor["tuketim"]["su"] = YazYanginRiski.gece(self, olaylar)
	rapor["tuketim"]["su"] += AmbarKundaklamasi.gece(self, olaylar)
	rapor["tuketim"]["gida"] = KurtBaskini.gece(self, olaylar)
	rapor["tuketim"]["saman"] = SamanBakimi.gece(self, olaylar)
	CatiKarBakimi.gece(self, olaylar)
	KisHastaligi.gece(self, olaylar)
	var calismalar := {}
	KanDavasi.gece(self, olaylar)
	MeslekGrevi.gece(self, olaylar)
	if isyan_kalan < 0:
		_uret(rapor["uretim"], olaylar, calismalar)
	else:
		olaylar.append({"anahtar": "koy.olay.isyan_uretim_yok"})
	SamanBakimi.hasat(self, rapor)
	GeceDeneyi.uretimin_ardindan(self)
	KoyluGelisimYoneticisi.gece(self, calismalar, olaylar)
	CirakEgitimi.gece(self, calismalar, olaylar)
	var uyanik_nobet := NobetYorgunlugu.nobetciler(self)
	IsKazalari.gece(self, calismalar, olaylar)
	ZanaatKazalari.gece(self, olaylar)
	KisHastaligi.tedavi(self, olaylar)
	NobetYorgunlugu.gece(self, uyanik_nobet)
	_insaat()
	_barindir()
	CasusGeceTakibi.gece(self)
	GizliEgilimler.gece(self, calismalar, olaylar)
	var hasat := HasatSenligi.hazir(self)
	_tuket(rapor["tuketim"], olaylar)
	rapor["su"] = SuDengesi.gece(self, rapor["tuketim"], olaylar)
	KuyuZehirleme.gece(self, rapor["su"], olaylar)
	rapor["ziyan"] = AmbarBakimi.gece(kaynaklar, gun, olaylar)
	IlkbaharTaskini.gece(self, olaylar)
	KrizEnjektoru.gece(self, olaylar)
	_saglik_ve_moral(rapor["olenler"], olaylar)
	IsMemnuniyeti.gece(self, calismalar, olaylar)
	CasusDevriyesi.gece(self, olaylar)
	FisiltiGazetesi.gece(self, olaylar)
	_akce(olaylar)
	_husumet(olaylar)
	asayis_riski = maxi(0, asayis_riski - a.asayis_sonum - etkin_muhafiz_sayisi() * a.muhafiz_asayis)
	HasatSenligi.uygula(self, hasat, olaylar)
	_isyan(olaylar)
	_asamalar(olaylar)
	IflasYoneticisi.gece(self, olaylar)
	_son_denetimi()
	rapor["akce"] = akce
	rapor["huzur"] = huzur()
	rapor["son"] = son
	gun += 1
	SiparisIhlali.gece(self, olaylar)
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
			if h.hazir() and katalog.slot(h.tur) > calisanlar(h.id).size() and YasRolleri.atanabilir(k, h.tur) and not bool(katalog.veri(h.tur).get("kis_durur", false)):
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
		if b != null and YasRolleri.atanabilir(k, b.tur) and calisanlar(eski).size() < katalog.slot(b.tur):
			k.is_yeri = eski


func _uret(uretim: Dictionary, olaylar: Array[Dictionary], calismalar: Dictionary = {}) -> void:
	lojistik.gece_basla(self, uretim)
	for b in binalar:
		b.bekliyor = ""
		if not b.hazir():
			continue
		if KanDavasi.engel(self, b.id):
			b.bekliyor = "kan_davasi"
			continue
		if b.recete == "": continue
		if kis_mi() and bool(katalog.veri(b.tur).get("kis_durur", false)):
			b.bekliyor = "kis"
			continue
		var r: Dictionary = katalog.receteler(b.tur).get(b.recete, {})
		var girdi: Dictionary = r.get("girdi", {})
		var cikti: Dictionary = r.get("uretim", {})
		var uzmanlik := String(katalog.veri(b.tur).get("uzmanlik", ""))
		for k in calisanlar(b.id):
			if not YasRolleri.fiziksel(k, b.tur): continue
			if ZanaatKazalari.durur(k):
				olaylar.append({"anahtar": "Köylü %s zanaat kazası nedeniyle bu gece üretemedi.", "deger": [k.ad]})
				continue
			if MeslekGrevi.aktif(k, self): continue
			if IsMemnuniyeti.isyanci(k, self):
				olaylar.append({"anahtar": "Köylü %d uyumsuz işini kişisel isyan eşiğinde reddetti.", "deger": [k.id]})
				continue
			var ambar_yeri_var := kaynaklar.toplam() < kaynaklar.kapasite
			var alet_kullanildi := kaynaklar.miktar("alet") > 0
			if not girdi.is_empty() and not kaynaklar.harca(girdi):
				b.bekliyor = "girdi"
				break
			var c := Uretim.koylu_carpani(k, uzmanlik, a, b.tur) * YasRolleri.carpan(self, b) * DemirZinciri.carpan(self, b.tur)
			var bonus := a.kritik_bonus if k.moral > a.kritik_moral else 0.0
			for t in cikti:
				var miktar := Uretim.gunluk(float(cikti[t]), k.stat, c) * b.uretim_carpani() * CanliHayvanTakasi.carpan(self, b, String(t))
				_ambara(b, t, miktar, miktar * bonus, uretim, olaylar)
			if not cikti.is_empty() and ambar_yeri_var: MeslekUyumu.alet_denetimi(self, k, b, olaylar)
			if not cikti.is_empty() and ambar_yeri_var:
				calismalar[k.id] = b.id
				if alet_kullanildi: DemirZinciri.calisildi(self, b.tur)
		# Usta danışman yalnız yanında gerçekten üretim yapıldıysa eğitim gecesi kazanır.
		if b.id in calismalar.values():
			for danisman in YasRolleri.danismanlar(self, b): calismalar[danisman.id] = b.id


## Üretimi ambara yazar; ambar doluysa üretim durur, kritik bonus ise tezgâh fiyatından akçeye döner (11.5).
func _ambara(b: KoyBinasi, tur: String, miktar: float, bonus: float, uretim: Dictionary, olaylar: Array[Dictionary]) -> void:
	var anahtar := "%d:%s" % [b.id, tur]
	var toplam := float(_artik.get(anahtar, 0.0)) + miktar
	var tam := int(toplam)
	_artik[anahtar] = toplam - tam
	var giren := lojistik.teslim(self, b.id, tam) if tur == "tomruk" else kaynaklar.ekle(tur, tam)
	uretim[tur] = int(uretim.get(tur, 0)) + giren
	if giren < tam:
		b.bekliyor = "tasima" if tur == "tomruk" and kaynaklar.toplam() < kaynaklar.kapasite else "ambar_dolu"
	if bonus > 0.0:
		var bonus_tam := int(round(bonus))
		var bonus_giren := lojistik.teslim(self, b.id, bonus_tam) if tur == "tomruk" else kaynaklar.ekle(tur, bonus_tam)
		uretim[tur] = int(uretim.get(tur, 0)) + bonus_giren
		var tasan := 0 if tur == "tomruk" else bonus_tam - bonus_giren
		if tasan > 0:
			var para := int(tasan * float(a.kervan_fiyat.get(tur, 0.0)) * a.tezgah_orani)
			if para > 0:
				akce += para
				olaylar.append({"anahtar": "koy.olay.bonus_satis", "deger": [tasan, para]})


func _insaat() -> void:
	var yardim := bostakiler().filter(func(k: Koylu) -> bool: return k.yas_grubu == &"yetiskin").size() / maxi(1, a.insa_yardim_bolen)
	for b in binalar:
		if b.insa_kalan > 0:
			b.insa_kalan = maxi(0, b.insa_kalan - 1 - yardim)
	_ambar_kapasitesi()


func _ambar_kapasitesi() -> void:
	var k := a.ambar_taban_kapasite
	for b in binalar:
		if b.hazir():
			k += b.depo_kapasitesi(katalog)
	kaynaklar.kapasite = k


## Evsizleri boş yataklara yerleştirir (9.3).
func _barindir() -> void:
	var dolu := {}
	for k in koylular:
		if DivanHukmu.zindanda(k): continue
		if k.ev >= 0 and bina(k.ev) != null:
			dolu[k.ev] = int(dolu.get(k.ev, 0)) + 1
		else:
			k.ev = -1
	for k in koylular:
		if DivanHukmu.zindanda(k): continue
		if k.ev >= 0:
			continue
		for b in binalar:
			if b.hazir() and b.yatak(katalog) > int(dolu.get(b.id, 0)):
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
	var ihtiyac := TuketimDengesi.gerek(self)
	var kisi_gida := float(ihtiyac.kisi_gida)
	var gerek := int(ihtiyac.gida)
	var yenen := kaynaklar.azalt("gida", gerek)
	tuketim["gida"] = int(tuketim.get("gida", 0)) + yenen
	var ac_sayisi := 0
	if yenen < gerek:
		ac_sayisi = ceili(float(gerek - yenen) / kisi_gida)
		olaylar.append({"anahtar": "koy.olay.aclik", "deger": [ac_sayisi]})
	# Açlık önce en son gelenlere düşer (en eski köylüler payını önce alır).
	for i in koylular.size():
		koylular[i].ac = i >= koylular.size() - ac_sayisi
	if kis_mi():
		var odun := int(ihtiyac.odun)
		var yakilan := kaynaklar.azalt("odun", odun)
		tuketim["odun"] = yakilan
		if yakilan < odun:
			DonmaYoneticisi.soguk(self)
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
			if k.ev >= 0 or DivanHukmu.zindanda(k):
				k.saglik += a.iyilesme
		if k.ev < 0 and not DivanHukmu.zindanda(k):
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
	MuhafizMaasi.ode(self, olaylar)
	VergiPolitikasi.tahsil(self, olaylar)


func _husumet(olaylar: Array[Dictionary]) -> void:
	var sonuc := KaraboranIntikami.tetikle(self, olaylar)
	if sonuc.is_empty(): sonuc = husumet.gece(a, etkin_muhafiz_sayisi(), _rng)
	else: husumet.puan = maxi(0, husumet.puan - a.husumet_sonum)
	match sonuc:
		"sizma":
			var g := kaynaklar.azalt("gida", maxi(3, kaynaklar.miktar("gida") / 6))
			var al := kaynaklar.azalt("alet", 1)
			olaylar.append({"anahtar": "koy.olay.sizma", "deger": [g, al]})
		"baskin": HusumetBaskini.uygula(self, olaylar)


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
		"iflas": iflas_durumu.duplicate(true), "vergi_politikasi": {"oran": vergi_orani, "son_gece": son_vergi_gece}, "maas_durumu": maas_durumu.duplicate(true), "alet_asinma": alet_asinma, "lojistik": lojistik.kaydet(), "gezgin_ticaret": gezgin_ticaret.kaydet(), "siparisler": siparisler.kaydet(), "tuccar_itibari": tuccar_itibari.duplicate(true), "tuccar_cezasi": tuccar_cezasi.duplicate(true), "tuccar_girisi": tuccar_girisi.duplicate(true), "kervan_koruma": kervan_koruma.duplicate(true), "husumet": husumet.kaydet(), "akce": akce, "gun": gun, "adalet": adalet, "asayis": asayis_riski,
		"isyan": isyan_kalan, "en_yuksek": en_yuksek_nufus, "kabul": kabul_sayisi, "ret": ret_sayisi, "agalik": agalik,
		"sur": sur_seviye, "sur_hasar": sur_hasar, "sur_taksit": sur_taksit_odenen, "vergi_muaf": vergi_muaf, "harac": harac_bekliyor,
		"tekfur": tekfur_baski, "savusturulan": savusturulan, "son": son, "sonraki_id": _sonraki_id, "artik": _artik.duplicate(),
		"tezgah": _tezgah_bugun, "rng": str(_rng.state), "iklim_deneyi": IklimDeneyi.ayar(self), "debug_kuyu_zehri": KrizEnjektoru.kalan(self), "ilkbahar_taskini": IlkbaharTaskini.durum(self), "su_doldurma": SuDengesi.durum(self), "hasat_senligi_yili": HasatSenligi.son_yil(self), "kurt_baskini_son_gece": KurtBaskini.oku(get_meta(KurtBaskini.META, -1)), "kis_hastaligi_son_gece": KisHastaligi.gece_oku(get_meta(KisHastaligi.META, -1)), "sifahane_kontenjani": SifahaneKontenjani.durum(self), "saman_son_gece": KurtBaskini.oku(get_meta(SamanBakimi.META, -1)), "casus_gece_takibi": CasusGeceTakibi.durum(self), "casus_devriyesi": CasusDevriyesi.durum(self), "kuyu_zehirleme": KuyuZehirleme.durum(self), "ambar_kundaklamasi": AmbarKundaklamasi.durum(self), "divan_oturumu": DivanOturumu.durum(self), "divan_hukumleri": DivanHukmu.durum(self), "karaboran_intikami": KaraboranIntikami.durum(self), "fisilti_gazetesi": FisiltiGazetesi.durum(self)}


static func kayittan(ayarlar: KoyAyarlari, katalog_: BinaKatalogu, v: Dictionary) -> KoyYonetimi:
	var y := KoyYonetimi.new(ayarlar, katalog_)
	IklimDeneyi.yukle(y, v.get("iklim_deneyi", {}))
	KrizEnjektoru.yukle(y, v.get("debug_kuyu_zehri", 0))
	IlkbaharTaskini.yukle(y, v.get("ilkbahar_taskini", {}))
	SuDengesi.yukle(y, v.get("su_doldurma", {}))
	y.set_meta(HasatSenligi.META, HasatSenligi.oku(v.get("hasat_senligi_yili", 0)))
	y.set_meta(KurtBaskini.META, KurtBaskini.oku(v.get("kurt_baskini_son_gece", -1)))
	y.set_meta(KisHastaligi.META, KisHastaligi.gece_oku(v.get("kis_hastaligi_son_gece", -1)))
	y.set_meta(SifahaneKontenjani.META, SifahaneKontenjani.oku(v.get("sifahane_kontenjani", {})))
	y.set_meta(SamanBakimi.META, KurtBaskini.oku(v.get("saman_son_gece", -1)))
	y.set_meta(CasusGeceTakibi.META, CasusGeceTakibi.oku(v.get("casus_gece_takibi", {})))
	y.set_meta(CasusDevriyesi.META, CasusDevriyesi.oku(v.get("casus_devriyesi", {})))
	y.set_meta(KuyuZehirleme.META, KuyuZehirleme.oku(v.get("kuyu_zehirleme", {})))
	y.set_meta(AmbarKundaklamasi.META, AmbarKundaklamasi.oku(v.get("ambar_kundaklamasi", {})))
	y.set_meta(DivanOturumu.META, DivanOturumu.oku(v.get("divan_oturumu", {})))
	y.set_meta(DivanHukmu.META, DivanHukmu.oku(v.get("divan_hukumleri", {})))
	y.set_meta(KaraboranIntikami.META, KaraboranIntikami.oku(v.get("karaboran_intikami", [])))
	y.set_meta(FisiltiGazetesi.META, FisiltiGazetesi.oku(v.get("fisilti_gazetesi", {})))
	y.iflas_durumu = IflasYoneticisi.oku(v.get("iflas", {}))
	VergiPolitikasi.yukle(y, v.get("vergi_politikasi", {}))
	y.maas_durumu = MuhafizMaasi.oku(v.get("maas_durumu", {}))
	y.alet_asinma = DemirZinciri.asinma_oku(v.get("alet_asinma", 0.0))
	y.lojistik = CekiLojistigi.kayittan(v.get("lojistik", {}))
	y.gezgin_ticaret = GezginTuccarStogu.kayittan(v.get("gezgin_ticaret", {}))
	y.siparisler = SiparisSozlesmeleri.kayittan(v.get("siparisler", {}))
	y.tuccar_itibari = SiparisTeslimati.oku(v.get("tuccar_itibari", {}))
	y.tuccar_cezasi = SiparisIhlali.oku(v.get("tuccar_cezasi", {}))
	y.tuccar_girisi = TuccarKapiGecisi.oku(v.get("tuccar_girisi", {}))
	y.kervan_koruma = KervanKorumasi.oku(v.get("kervan_koruma", {}))
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
	y.sur_hasar = int(v.get("sur_hasar", 0))
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
		y._rng.state = String(v["rng"]).to_int() if v["rng"] is String else int(v["rng"])
	DivanHukmu.kayit_esitle(y)
	y._ambar_kapasitesi()
	return y
