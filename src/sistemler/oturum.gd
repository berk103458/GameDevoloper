## Bir oyun oturumu: gün döngüsü, kuyruk, karar, gece sonu çözümü ve kayıt.
## Kurallar: design/gdd/oyun-durumu-ve-gun-dongusu.md ve karakter-kadrosu.md;
## Barlar, Karar ve savunma için prototipte sınanan geçici kurallar (Open Questions).
class_name Oturum
extends RefCounted

const KAYIT_SURUMU := 1

var katalog: Katalog
var ayarlar: OyunAyarlari
var barlar: Barlar
var koy: KoyNufusu
var kadro: KarakterKadrosu
## Tamamlanan gece sayısı = skor.
var gun: int = 0
## 1 = kapı ve köy, 2 = ağalık ve savunma.
var perde: int = 1
var perde2_gece: int = 0
var rusvet_hakki: int = 3
var tohum: int = 0
var akce: int = 0
var ambar: int = 0
## Yapı seviyeleri (0 = yok): pazar, kervansaray, sur.
var yapilar: Dictionary = {&"pazar": 0, &"kervansaray": 0, &"sur": 0, &"konak": 0}
## Olayların bıraktığı işaretler (kararların uzun vadeli izleri).
var bayraklar: Dictionary = {}
var gorulen_olaylar: Dictionary = {}
## Bir sonraki gecenin gelen sayısına ek (olaylardan).
var sonraki_gelen_ek: int = 0
var _rng: RandomNumberGenerator
var _rng_donus: RandomNumberGenerator
var _rng_ad: RandomNumberGenerator
## Heybe içeriği için ayrı akış (yalan ve eşyalar diğer çekilişleri kaydırmasın).
var _rng_heybe: RandomNumberGenerator
## Köyün tarlaları ve ekinleri.
var tarlalar := Tarlalar.new()
var _gemini: Array = []
var _gemini_sira: int = 0


## Yeni oturum. `tohum` 0 ise rastgele seçilir.
func _init(katalog_: Katalog, tohum_: int = 0) -> void:
	katalog = katalog_
	ayarlar = katalog.ayarlar
	tohum = tohum_ if tohum_ != 0 else int(Time.get_unix_time_from_system()) ^ randi()
	_rng = RandomNumberGenerator.new()
	_rng.seed = tohum
	_rng_donus = RandomNumberGenerator.new()
	_rng_donus.seed = tohum + 1
	_rng_ad = RandomNumberGenerator.new()
	_rng_ad.seed = tohum + 2
	_rng_heybe = RandomNumberGenerator.new()
	_rng_heybe.seed = tohum + 3
	barlar = Barlar.new(ayarlar.bar_anahtarlari.size(), ayarlar.bar_baslangic, ayarlar.bar_azami)
	koy = KoyNufusu.new()
	kadro = KarakterKadrosu.new(katalog, _rng_donus, _rng_ad)
	rusvet_hakki = ayarlar.rusvet_hakki
	akce = ayarlar.akce_baslangic
	ambar = ayarlar.ambar_baslangic


## Gösterilen gece numarası (1'den).
func gosterilen_gece() -> int:
	return gun + 1


## Bu gecenin varış listesi.
func gece_kuyrugu() -> Array[Gelen]:
	koy.bu_gece_girenler = []
	var sayi := ayarlar.gece_basina_gelen if perde == 1 else ayarlar.perde2_gece_basina_gelen
	if yapilar[&"kervansaray"] >= 2:
		sayi += 1
	sayi = maxi(1, sayi + sonraki_gelen_ek)
	sonraki_gelen_ek = 0
	var uygun := kadro.uygunlar(gun)
	var sonuc: Array[Gelen] = []
	for i in sayi:
		if not uygun.is_empty() and _rng.randf() < ayarlar.adli_olasiligi:
			var id: StringName = uygun.pop_at(_rng.randi_range(0, uygun.size() - 1))
			kadro.iste(id, gun)
			sonuc.append(_adli_gelen(id))
		else:
			sonuc.append(_figur_gelen())
	for g in sonuc:
		g.heybe = heybe_uret(g.sinif)
	return sonuc


## Bir gelenin heybesi: söylediği akçe, sınıfına göre 1–2 eşya; yalancının astarında akçe ve
## bazen değerli bir eşya (design/gdd/heybe-ve-rusvet.md, F1–F3).
func heybe_uret(sinif: StringName) -> Heybe:
	var h := Heybe.new()
	var a := ayarlar
	var beyan := _rng_heybe.randi_range(a.beyan_akce_min, a.beyan_akce_max)
	h.ekle("akce", "akce", 1, beyan, false)
	var adaylar: Array[int] = []
	var degerliler: Array[int] = []
	for i in a.esya_idleri.size():
		if a.esya_idleri[i] == "akce":
			continue
		if a.esya_gizli[i] == 1:
			degerliler.append(i)
			continue
		var kim := a.esya_siniflari[i]
		if kim == "*" or String(sinif) in kim.split(","):
			adaylar.append(i)
	for n in _rng_heybe.randi_range(1, 2):
		if adaylar.is_empty():
			break
		var i: int = adaylar.pop_at(_rng_heybe.randi_range(0, adaylar.size() - 1))
		h.ekle(a.esya_idleri[i], a.esya_turleri[i], a.esya_degerleri[i], 1, false)
	h.teklif = maxi(1, ceili(beyan * a.teklif_orani))
	if _rng_heybe.randf() < a.yalan_olasiligi:
		h.ekle("akce", "akce", 1, _rng_heybe.randi_range(a.gizli_akce_min, a.gizli_akce_max), true)
		if not degerliler.is_empty() and _rng_heybe.randf() < a.gizli_esya_olasiligi:
			var i: int = degerliler[_rng_heybe.randi_range(0, degerliler.size() - 1)]
			h.ekle(a.esya_idleri[i], a.esya_turleri[i], a.esya_degerleri[i], 1, true)
	return h


## Sohbet açıldı (adlı karakterde ziyaret sayılır).
func ziyaret_basladi(gelen: Gelen) -> void:
	if gelen.adli:
		kadro.ziyaret_basladi(gelen.id, gun)


## Karar uygulanır. Döner: {kaldi, kirilan (-1), rusvet_harcandi (bar indeksi ya da -1),
## alinan (heybeden alınanların listesi), alinan_akce, alinan_ambar, gasp (bool), durust_arandi (bool)}.
## "elkoy": astardan çıkanlara el konur, gelen geri çevrilir (yalnız yalan yakalanınca).
func karar_ver(gelen: Gelen, karar: StringName, is_yeri: StringName = &"") -> Dictionary:
	var h := gelen.heybe
	var ek := {"alinan": [], "alinan_akce": 0, "alinan_ambar": 0, "gasp": false, "durust_arandi": false}
	if karar == &"elkoy":
		barlar.uygula(gelen.etkiler.get(&"ret", PackedInt32Array()))
	else:
		barlar.uygula(gelen.etkiler.get(karar, PackedInt32Array()))
	if h != null:
		if karar == &"rusvet" and not h.alinan_var():
			h.teklifi_sec()
		elif karar == &"elkoy":
			h.saklananlari_sec()
		if karar == &"rusvet" or karar == &"elkoy":
			var d := h.alinan_dagilim()
			akce += d["akce"]
			ambar += d["ambar"]
			ek["alinan_akce"] = d["akce"]
			ek["alinan_ambar"] = d["ambar"]
			for e in h.esyalar:
				if int(e["alinan"]) > 0:
					ek["alinan"].append({"id": e["id"], "adet": e["alinan"]})
			if h.gasp() > 0:
				barlar.ekle(0, -ayarlar.gasp_halk_cezasi)
				ek["gasp"] = true
		if h.astar_yoklandi and not h.yalan_var():
			barlar.ekle(0, -ayarlar.durust_arama_cezasi)
			ek["durust_arandi"] = true
	elif karar == &"rusvet":
		akce += ayarlar.rusvet_akce
	if karar == &"rusvet":
		bayraklar[&"rusvet_sayisi"] = int(bayraklar.get(&"rusvet_sayisi", 0)) + 1
	var kaldi := karar != &"ret" and karar != &"elkoy"
	ek["is_yeri"] = is_yeri
	ek["uyumsuz"] = false
	if kaldi:
		var sinif: StringName = &"asker" if karar == &"kisla" else gelen.sinif
		var i := ayarlar.is_idleri.find(String(is_yeri))
		if i >= 0:
			# Kişi yazıldığı işi yapar; işe uygun değilse oranın barı düşer.
			sinif = StringName(ayarlar.is_siniflari[i])
			if sinif != gelen.sinif:
				barlar.ekle(ayarlar.is_barlari[i], -ayarlar.uyumsuz_ceza)
				ek["uyumsuz"] = true
				ek["uyumsuz_bar"] = ayarlar.is_barlari[i]
		koy.ekle(sinif, gelen.id if gelen.adli else &"", "soldier_01" if karar == &"kisla" and not gelen.adli else gelen.portre)
	if gelen.adli:
		kadro.sonuc(gelen.id, kaldi, karar, gun)
	var sonuc := _bar_cozumu()
	sonuc["kaldi"] = kaldi
	sonuc.merge(ek)
	return sonuc


## Gece sonu çözümü (GDD 1 sırası: üretim ve baskılar → bar → son → köy oturdu → sayaç → olay).
## Döner: {olaylar: Array[Dictionary] {anahtar, deger}, kirilan, rusvet_harcandi, son, perde_degisti, olay: OlayVerisi|null}
func gece_sonu() -> Dictionary:
	var olaylar: Array[Dictionary] = []
	var toplam := koy.toplam()
	# Ambar: çiftçi üretir, herkes yer.
	var uretim := koy.sayi(&"ciftci") * ayarlar.ciftci_uretim + (2 if bayraklar.has(&"tarla") else 0)
	var tuketim := ceili(toplam / float(ayarlar.tuketim_bolen))
	ambar += uretim - tuketim
	olaylar.append({"anahtar": "anlati.ambar", "deger": [uretim, tuketim]})
	# Tarlalar: ekinler büyür, olgunlaşanlar ambara.
	for h in tarlalar.gece(ayarlar.bitki_sure_sozlugu(), ayarlar.bitki_verim_sozlugu()):
		ambar += int(h["verim"])
		olaylar.append({"anahtar": "anlati.hasat." + String(h["bitki"]), "deger": [h["verim"]]})
	tarlalar.alan_guncelle(koy.sayi(&"ciftci"), ayarlar.ciftci_tarla_basina, ayarlar.tarla_azami)
	if ambar < 0:
		ambar = 0
		barlar.ekle(0, -1)
		olaylar.append({"anahtar": "anlati.baski.gida"})
	# Akçe: esnaf ve pazar, kervansaray.
	# Pazar, kaç esnafın alışveriş edebildiğini sınırlar: 2 + 2 × seviye.
	var satan := mini(koy.sayi(&"esnaf"), ayarlar.pazar_tezgah_taban + ayarlar.pazar_tezgah_artis * int(yapilar[&"pazar"]))
	var gelir: int = satan * ayarlar.esnaf_gelir + int(yapilar[&"kervansaray"]) * ayarlar.kervansaray_gelir
	if gelir > 0:
		akce += gelir
		olaylar.append({"anahtar": "anlati.gelir", "deger": [gelir]})
	# Asker maaşı: her iki asker bir akçe. Ödenemezse Ordu düşer.
	var maas := koy.sayi(&"asker") / 2
	if maas > 0:
		if akce >= maas:
			akce -= maas
			olaylar.append({"anahtar": "anlati.maas", "deger": [maas]})
		else:
			akce = 0
			barlar.ekle(3, -1)
			olaylar.append({"anahtar": "anlati.maas_yok"})
	if perde == 1:
		if gun >= ayarlar.ordu_baski_gecesi and koy.sayi(&"asker") * 2 < gun:
			barlar.ekle(3, -1)
			olaylar.append({"anahtar": "anlati.baski.ordu"})
		if gun >= ayarlar.tuccar_baski_gecesi and koy.sayi(&"esnaf") == 0 and yapilar[&"pazar"] == 0:
			barlar.ekle(2, -1)
			olaylar.append({"anahtar": "anlati.baski.tuccar"})
	else:
		var saldiri := saldiri_gucu()
		var savunma := savunma_gucu()
		olaylar.append({"anahtar": "anlati.saldiri.guc", "deger": [saldiri, savunma]})
		if saldiri > savunma:
			barlar.ekle(3, -1)
			barlar.ekle(0, -1)
			if saldiri - savunma >= 2 and koy.toplam() > 0:
				koy.cikar_rastgele(1, _rng)
				olaylar.append({"anahtar": "anlati.saldiri.kayip"})
			olaylar.append({"anahtar": "anlati.saldiri.agir"})
		else:
			olaylar.append({"anahtar": "anlati.saldiri.puskurtuldu"})
	if (gun + 1) % ayarlar.vergi_araligi == 0 and not bayraklar.has(&"bey_dostu"):
		barlar.ekle(1, -1)
		olaylar.append({"anahtar": "anlati.baski.vergi"})
	var sonuc := _bar_cozumu()
	sonuc["olaylar"] = olaylar
	sonuc["son"] = &""
	sonuc["perde_degisti"] = false
	sonuc["olay"] = null
	if sonuc["kirilan"] >= 0:
		sonuc["son"] = &"kirildi"
		return sonuc
	gun += 1
	kadro.gece_bitti()
	if perde == 2:
		perde2_gece += 1
		if perde2_gece >= ayarlar.perde2_hedef_gece:
			sonuc["son"] = son_belirle()
			return sonuc
	elif koy.toplam() >= ayarlar.oturma_esigi:
		perde = 2
		sonuc["perde_degisti"] = true
		return sonuc
	sonuc["olay"] = olay_sec()
	return sonuc


## İkinci perdede Tekfur'un saldırı gücü.
func saldiri_gucu() -> int:
	var g := ayarlar.saldiri_taban + perde2_gece / ayarlar.saldiri_artis_araligi
	if bayraklar.has(&"harac"):
		g -= 2
	return maxi(0, g)


## Köyün savunması: asker ve sur.
func savunma_gucu() -> int:
	var s: int = koy.sayi(&"asker") / ayarlar.savunma_bolen + yapilar[&"sur"] * 2
	if bayraklar.has(&"ertugrul"):
		s += 1
	return s


## İkinci perdenin sonunda hangi son: köyün durumuna göre.
func son_belirle() -> StringName:
	var b := barlar.degerler
	if bayraklar.has(&"ertugrul") and b[3] >= 6:
		return &"ertugrul"
	if bayraklar.has(&"ahi_ocagi") and yapilar[&"pazar"] >= 2:
		return &"ahi"
	if bayraklar.has(&"harac"):
		return &"harac"
	if bayraklar.has(&"bey_dostu") and b[1] >= 7:
		return &"bey"
	return &"tutundu"


# ─── Yapılar ─────────────────────────────────────────────────────────────

## Bir yapının bir sonraki seviyesi için {bedel, esnaf, olur: bool}; azamideyse bedel -1.
func yapi_durumu(yapi: StringName) -> Dictionary:
	var seviye: int = yapilar[yapi]
	var bedeller: PackedInt32Array
	match yapi:
		&"pazar":
			bedeller = ayarlar.pazar_bedel
		&"kervansaray":
			bedeller = ayarlar.kervansaray_bedel
		&"konak":
			bedeller = ayarlar.konak_bedel
		_:
			bedeller = ayarlar.sur_bedel
	if seviye >= bedeller.size():
		return {"bedel": -1, "esnaf": 0, "nufus": 0, "olur": false}
	if yapi == &"konak":
		var nufus := ayarlar.konak_nufus[seviye]
		return {"bedel": bedeller[seviye], "esnaf": 0, "nufus": nufus, "olur": akce >= bedeller[seviye] and koy.toplam() >= nufus}
	var esnaf := 0
	if yapi == &"pazar":
		esnaf = ayarlar.pazar_esnaf[seviye]
	elif yapi == &"kervansaray":
		esnaf = ayarlar.kervansaray_esnaf[seviye]
	var bedel := bedeller[seviye]
	return {"bedel": bedel, "esnaf": esnaf, "nufus": 0, "olur": akce >= bedel and koy.sayi(&"esnaf") >= esnaf}


func yapi_kur(yapi: StringName) -> bool:
	var d := yapi_durumu(yapi)
	if not d["olur"]:
		return false
	akce -= d["bedel"]
	yapilar[yapi] = int(yapilar[yapi]) + 1
	if yapi == &"kervansaray":
		barlar.ekle(2, 1)
	elif yapi == &"pazar":
		barlar.ekle(0, 1)
	elif yapi == &"konak":
		barlar.ekle(1, 1)
	return true


func kese_alinabilir() -> bool:
	return rusvet_hakki < ayarlar.rusvet_hakki and akce >= ayarlar.kese_fiyati


func kese_al() -> bool:
	if not kese_alinabilir():
		return false
	akce -= ayarlar.kese_fiyati
	rusvet_hakki += 1
	return true


# ─── Olaylar ─────────────────────────────────────────────────────────────

## Bu gece sonu için uygun bir olay (ağırlıklı rastgele) ya da null.
func olay_sec() -> OlayVerisi:
	if _rng.randf() >= ayarlar.olay_olasiligi:
		return null
	var adaylar: Array[OlayVerisi] = []
	var toplam_agirlik := 0.0
	for o in katalog.olaylar():
		if o.tek_sefer and gorulen_olaylar.has(o.id):
			continue
		if not _kosul_tutar(o.kosullar):
			continue
		adaylar.append(o)
		toplam_agirlik += o.agirlik
	if adaylar.is_empty():
		return null
	var r := _rng.randf() * toplam_agirlik
	for o in adaylar:
		r -= o.agirlik
		if r <= 0.0:
			gorulen_olaylar[o.id] = true
			return o
	gorulen_olaylar[adaylar[-1].id] = true
	return adaylar[-1]


## İki gelen arasında kuyrukta bir olay (ağırlıklı rastgele) ya da null. `kuyruk`: sırada bekleyen sayısı.
func sira_olayi_sec(kuyruk: int) -> OlayVerisi:
	if kuyruk <= 0 or _rng.randf() >= ayarlar.sira_olay_olasiligi:
		return null
	var adaylar: Array[OlayVerisi] = []
	var toplam := 0.0
	for o in katalog.sira_olaylari():
		if kuyruk < int(o.kosullar.get("kuyruk_min", 1)):
			continue
		adaylar.append(o)
		toplam += o.agirlik
	if adaylar.is_empty():
		return null
	var r := _rng.randf() * toplam
	for o in adaylar:
		r -= o.agirlik
		if r <= 0.0:
			return o
	return adaylar[-1]


## Bir seçeneğin gereklilikleri karşılanıyor mu.
func secenek_olur(olay: OlayVerisi, i: int) -> bool:
	var e: Dictionary = olay.secenek_etkileri[i]
	var g: Dictionary = e.get("gerekli", {})
	if akce < int(g.get("akce", 0)) or ambar < int(g.get("ambar", 0)):
		return false
	for id in g.get("koyde", []):
		if kadro.durumlar.get(StringName(id), {}).get("durum") != &"koyde":
			return false
	return true


## Seçeneği uygular. Döner: {kirilan, rusvet_harcandi, sonuc_anahtari}.
func olay_uygula(olay: OlayVerisi, i: int) -> Dictionary:
	var e: Dictionary = olay.secenek_etkileri[i]
	var g: Dictionary = e.get("gerekli", {})
	akce -= int(g.get("akce", 0))
	ambar -= int(g.get("ambar", 0))
	if e.has("bar"):
		barlar.uygula(PackedInt32Array(e["bar"]))
	akce = maxi(0, akce + int(e.get("akce", 0)))
	ambar = maxi(0, ambar + int(e.get("ambar", 0)))
	rusvet_hakki = clampi(rusvet_hakki + int(e.get("kese", 0)), 0, ayarlar.rusvet_hakki)
	sonraki_gelen_ek += int(e.get("sonraki_gelen", 0))
	var nufus: Dictionary = e.get("nufus", {})
	for sinif in nufus:
		var n := int(nufus[sinif])
		for k in absi(n):
			if n > 0:
				koy.ekle(StringName(sinif))
			else:
				koy.cikar(StringName(sinif))
	if e.has("bayrak"):
		bayraklar[StringName(e["bayrak"])] = true
	tarlalar.gun_ekle(int(e.get("tarla_gun", 0)))
	if e.has("tarla_verim"):
		tarlalar.verim_carp(float(e["tarla_verim"]))
	if e.has("tarla_don"):
		tarlalar.genc_yok_et(ayarlar.don_esigi)
	if e.has("ayril"):
		var id := StringName(e["ayril"])
		if kadro.durumlar.has(id) and kadro.durumlar[id]["durum"] == &"koyde":
			kadro.durumlar[id]["durum"] = &"kalici_ayrildi"
			koy.cikar(katalog.karakter(id).sinif, id)
	var sonuc := _bar_cozumu()
	sonuc["sonuc_anahtari"] = "%s.sonuc%d" % [olay.metin_anahtari.trim_suffix(".metin"), i + 1]
	return sonuc


func _kosul_tutar(k: Dictionary) -> bool:
	if gun < int(k.get("gece_min", 0)) or gun > int(k.get("gece_max", 9999)):
		return false
	if k.has("perde") and perde != int(k["perde"]):
		return false
	for id in k.get("koyde", []):
		if kadro.durumlar.get(StringName(id), {}).get("durum") != &"koyde":
			return false
	for id in k.get("ayrildi", []):
		if not kadro.durumlar.get(StringName(id), {}).get("durum") in [&"kalici_ayrildi", &"donebilir"]:
			return false
	for b in k.get("bayrak", []):
		if not bayraklar.has(StringName(b)):
			return false
	for b in k.get("bayrak_yok", []):
		if bayraklar.has(StringName(b)):
			return false
	if koy.toplam() < int(k.get("nufus_min", 0)):
		return false
	if tarlalar.ekili_sayisi() < int(k.get("tarla_ekili_min", 0)):
		return false
	var sm: Dictionary = k.get("sinif_min", {})
	for s in sm:
		if koy.sayi(StringName(s)) < int(sm[s]):
			return false
	if ambar > int(k.get("ambar_max", 9999)) or akce < int(k.get("akce_min", 0)):
		return false
	var ym: Dictionary = k.get("yapi_min", {})
	for y in ym:
		if int(yapilar.get(StringName(y), 0)) < int(ym[y]):
			return false
	var bm: Dictionary = k.get("bar_max", {})
	for i in bm:
		if barlar.degerler[int(i)] > int(bm[i]):
			return false
	var bmin: Dictionary = k.get("bar_min", {})
	for i in bmin:
		if barlar.degerler[int(i)] < int(bmin[i]):
			return false
	if k.has("sans") and _rng.randf() >= float(k["sans"]):
		return false
	return true


## Kırılan bar varsa önce rüşvet hakkı harcanır.
func _bar_cozumu() -> Dictionary:
	var sonuc := {"kirilan": -1, "rusvet_harcandi": -1}
	var i := barlar.kirilan()
	while i >= 0:
		if rusvet_hakki > 0:
			rusvet_hakki -= 1
			barlar.ayarla(i, ayarlar.rusvet_kurtarma)
			sonuc["rusvet_harcandi"] = i
			i = barlar.kirilan()
		else:
			sonuc["kirilan"] = i
			break
	return sonuc


func _adli_gelen(id: StringName) -> Gelen:
	var k := katalog.karakter(id)
	var s := katalog.sohbet(k.sohbet_id)
	var g := Gelen.new()
	g.adli = true
	g.id = id
	g.ad_anahtari = k.ad_anahtari
	g.sinif = k.sinif
	g.portre = k.portre
	var ziyaret := int(kadro.durumlar[id]["ziyaret"]) + 1
	g.giris_anahtari = s.giris(ziyaret)
	g.acilis = s.acilis(ziyaret)
	var yerel := {}
	for i in s.sorular(ziyaret):
		yerel[i] = g.sorular.size()
		g.sorular.append(PackedStringArray([s.soru_anahtarlari[i], s.cevap_anahtarlari[i]]))
	for i in s.sorular(ziyaret):
		g.soru_ust.append(int(yerel.get(s.ust(i), -1)))
	g.secenekler = _perde_secenekleri(k.karar_secenekleri)
	for karar in g.secenekler:
		g.etkiler[StringName(karar)] = k.etki(karar)
	return g


## Sıradaki hazır diyalog (data/diyalog). Her biri oyun başına bir kez gelir; bitince boş döner
## ve adsız gelenler sınıf şablonlarına düşer (aynı kişi ikinci kez kapıya gelmez).
func _gemini_al() -> Dictionary:
	if _gemini.is_empty():
		var metin := FileAccess.get_file_as_string("res://data/diyalog/diyalog_01_20.json")
		var ayris = JSON.parse_string(metin)
		if ayris is Array:
			_gemini = ayris
	if _gemini_sira >= _gemini.size():
		return {}
	var d: Dictionary = _gemini[_gemini_sira]
	_gemini_sira += 1
	return d


func _figur_gelen() -> Gelen:
	var d := _gemini_al()
	if d.is_empty():
		return _figur_sablon()
	var sablon := katalog.sinif(StringName(String(d["sinif"])))
	var ornek := kadro.figur_ornegi(sablon)
	var g := Gelen.new()
	g.ad_anahtari = ornek["ad_anahtari"]
	g.sinif = sablon.sinif
	g.portre = sablon.portreler[0]
	g.giris_anahtari = String(d["sahne"])
	g.acilis = String(d.get("acilis", ""))
	_json_sorular(g, d["sorular"], -1)
	var tum: Array = []
	for i in d["secenekler"].size():
		tum.append({"k": String(d["secenekler"][i]), "e": int(d["esik"][i])})
	if perde != 1:
		var sade: Array = []
		for o in tum:
			if o["k"] == "kabul" or o["k"] == "ret":
				sade.append(o)
		tum = sade
	g.secenekler = PackedStringArray()
	g.esikler = PackedInt32Array()
	for o in tum:
		g.secenekler.append(o["k"])
		g.esikler.append(int(o["e"]))
	g.yanitlar = d["yanitlar"]
	for karar in g.secenekler:
		var etki := sablon.etki(karar).duplicate()
		if karar == "kabul":
			etki[_rng.randi_range(0, etki.size() - 1)] += 1 if _rng.randf() < 0.5 else -1
		g.etkiler[StringName(karar)] = etki
	return g


## JSON diyalogdaki soru ağacını düzler: [soru, cevap, [takipler]].
func _json_sorular(g: Gelen, liste: Array, ust: int) -> void:
	for cift in liste:
		var i := g.sorular.size()
		g.sorular.append(PackedStringArray([String(cift[0]), String(cift[1])]))
		g.soru_ust.append(ust)
		if cift.size() > 2 and cift[2] is Array:
			_json_sorular(g, cift[2], i)


func _figur_sablon() -> Gelen:
	var siniflar := Katalog.SINIFLAR
	var sablon := katalog.sinif(siniflar[_rng.randi_range(0, siniflar.size() - 1)])
	var ornek := kadro.figur_ornegi(sablon)
	var cesit: int = ornek["cesit"]
	var g := Gelen.new()
	g.ad_anahtari = ornek["ad_anahtari"]
	g.sinif = sablon.sinif
	g.portre = sablon.portreler[cesit]
	g.giris_anahtari = sablon.giris_anahtarlari[cesit]
	if cesit < sablon.acilis_anahtarlari.size():
		g.acilis = sablon.acilis_anahtarlari[cesit]
	var yerel := {}
	for i in sablon.soru_anahtarlari.size():
		if sablon.soru_cesidi[i] == cesit:
			yerel[i] = g.sorular.size()
			g.sorular.append(PackedStringArray([sablon.soru_anahtarlari[i], sablon.cevap_anahtarlari[i]]))
			var u: int = sablon.soru_ust[i] if i < sablon.soru_ust.size() else -1
			g.soru_ust.append(int(yerel.get(u, -1)))
	g.secenekler = _perde_secenekleri(sablon.karar_secenekleri)
	for karar in g.secenekler:
		var etki := sablon.etki(karar).duplicate()
		# Figürlerde gizli küçük fark: kabulün bir bara ek etkisi.
		if karar == "kabul":
			etki[_rng.randi_range(0, etki.size() - 1)] += 1 if _rng.randf() < 0.5 else -1
		g.etkiler[StringName(karar)] = etki
	return g


## İkinci perdede kapı sade bir süzgeçtir: yalnız kabul ve ret.
func _perde_secenekleri(secenekler: PackedStringArray) -> PackedStringArray:
	if perde == 1:
		return secenekler
	return PackedStringArray(["kabul", "ret"])


## Boş bir tarlaya ürün eker; tohum ambardan düşer. Döner: ekildi mi.
func tarla_ek(bitki: String) -> bool:
	var i := ayarlar.bitki_idleri.find(bitki)
	if i < 0 or ambar < ayarlar.bitki_tohumlari[i] or tarlalar.bos_sayisi() == 0:
		return false
	ambar -= ayarlar.bitki_tohumlari[i]
	return tarlalar.ek(bitki)


## Kapıda seçilebilen iş yerleri (gereken yapı kurulmuşsa).
func is_yerleri() -> PackedStringArray:
	var s := PackedStringArray()
	for i in ayarlar.is_idleri.size():
		var y := ayarlar.is_yapilari[i]
		if y == "" or int(yapilar.get(StringName(y), 0)) > 0:
			s.append(ayarlar.is_idleri[i])
	return s


## Gece sonu kaydı için sözlük.
func kaydet() -> Dictionary:
	return {"surum": KAYIT_SURUMU, "tohum": str(tohum), "gun": gun, "perde": perde, "perde2_gece": perde2_gece,
		"rusvet_hakki": rusvet_hakki, "barlar": Array(barlar.degerler),
		"akce": akce, "ambar": ambar, "sonraki_gelen_ek": sonraki_gelen_ek,
		"yapilar": {"pazar": yapilar[&"pazar"], "kervansaray": yapilar[&"kervansaray"], "sur": yapilar[&"sur"], "konak": yapilar[&"konak"]},
		"bayraklar": bayraklar.keys().map(func(x): return String(x)),
		"rusvet_sayisi": int(bayraklar.get(&"rusvet_sayisi", 0)),
		"gorulen_olaylar": gorulen_olaylar.keys().map(func(x): return String(x)),
		"koy": {"asker": koy.sayi(&"asker"), "esnaf": koy.sayi(&"esnaf"), "ciftci": koy.sayi(&"ciftci")},
		"koy_adlilar": koy.adlilar.map(func(x): return String(x)),
		"kadro": kadro.kaydet(),
		"diyalog_sira": _gemini_sira,
		"tarlalar": tarlalar.kaydet(),
		"rng": [str(_rng.state), str(_rng_donus.state), str(_rng_ad.state), str(_rng_heybe.state)]}
	# 64 bit sayılar JSON'da float'a döner; metin olarak saklanır.


## Kayıttan oturum kurar; geçersizse null.
static func kayittan(katalog_: Katalog, veri: Dictionary) -> Oturum:
	if int(veri.get("surum", 0)) != KAYIT_SURUMU:
		push_error("Kayıt sürümü uyuşmuyor")
		return null
	var gun_: float = veri.get("gun", -1)
	var perde_: int = int(veri.get("perde", 0))
	if gun_ < 0 or gun_ != floorf(gun_) or not perde_ in [1, 2]:
		push_error("Kayıt geçersiz: gün/perde")
		return null
	var o := Oturum.new(katalog_, String(veri["tohum"]).to_int())
	o.gun = int(gun_)
	o.perde = perde_
	o.perde2_gece = int(veri.get("perde2_gece", 0))
	o.rusvet_hakki = int(veri.get("rusvet_hakki", 0))
	o.akce = int(veri.get("akce", 0))
	o.ambar = int(veri.get("ambar", 0))
	o.sonraki_gelen_ek = int(veri.get("sonraki_gelen_ek", 0))
	var y: Dictionary = veri.get("yapilar", {})
	for k in o.yapilar.keys():
		o.yapilar[k] = int(y.get(String(k), 0))
	for b in veri.get("bayraklar", []):
		o.bayraklar[StringName(b)] = true
	if int(veri.get("rusvet_sayisi", 0)) > 0:
		o.bayraklar[&"rusvet_sayisi"] = int(veri["rusvet_sayisi"])
	for g in veri.get("gorulen_olaylar", []):
		o.gorulen_olaylar[StringName(g)] = true
	var b: Array = veri.get("barlar", [])
	for i in mini(b.size(), o.barlar.degerler.size()):
		o.barlar.degerler[i] = int(b[i])
	var k: Dictionary = veri.get("koy", {})
	for s in [&"asker", &"esnaf", &"ciftci"]:
		o.koy.sayilar[s] = int(k.get(String(s), 0))
	for a in veri.get("koy_adlilar", []):
		o.koy.adlilar.append(StringName(a))
	if not o.kadro.yukle(veri.get("kadro", {})):
		return null
	var r: Array = veri.get("rng", [])
	if r.size() >= 3:
		o._rng.state = String(r[0]).to_int()
		o._rng_donus.state = String(r[1]).to_int()
		o._rng_ad.state = String(r[2]).to_int()
	if r.size() >= 4:
		o._rng_heybe.state = String(r[3]).to_int()
	o._gemini_sira = int(veri.get("diyalog_sira", 0))
	o.tarlalar.yukle(veri.get("tarlalar", []))
	o.tarlalar.alan_guncelle(o.koy.sayi(&"ciftci"), o.ayarlar.ciftci_tarla_basina, o.ayarlar.tarla_azami)
	return o
