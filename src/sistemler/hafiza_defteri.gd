## HFZ-01…12, HFZ-17, HFZ-20, HFZ-21, HFZ-23, HFZ-24, HFZ-26…29
## Tek okuma yuzeyi. Kaynak sistemlere yazmaz; satirlar DIY-14, DYL-08, CAS-07,
## DIY-07, SOY-29 ve OGR-10 kaydindan okunur. Metin yer tutucu anahtardir.
class_name HafizaDefteri
extends RefCounted

const SAYFALAR: Array[String] = ["karar", "beyan", "soylenti", "not"]
const DIS_HATLAR: Array[String] = ["sancak", "tekfur", "mogol", "oba"]
const GITTI_DURUMLARI: Array[String] = ["oldu", "öldü", "gitti", "ayrildi", "kalici_ayrildi", "surgun", "infaz"]
const VARSAYILAN_TAVAN := 40
const TAVAN_YOLU := "res://data/hafiza.json"
const NOT_ANAHTARI := "UI_BU_HATIRLANACAK"
const NOT_SINIRI := 5

var yazim_sayisi: int = 0
var okunan: Array[String] = []
var _debug_satirlar: Array[Dictionary] = []
var _tavan: int = VARSAYILAN_TAVAN
var _tavan_hazir: bool = false


func tavan_yukle(yol: String = TAVAN_YOLU) -> int:
	_tavan = VARSAYILAN_TAVAN
	_tavan_hazir = true
	if not FileAccess.file_exists(yol):
		return _tavan
	var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	if veri is Dictionary and (veri as Dictionary).has("karar_tavan"):
		_tavan = maxi(int((veri as Dictionary)["karar_tavan"]), 1)
	return _tavan


func tavan() -> int:
	if not _tavan_hazir:
		tavan_yukle()
	return _tavan


func kaynak_yazimi() -> int:
	return yazim_sayisi


func sabah_evresinde_acilir_mi() -> bool:
	return false


func bos_anahtari(sayfa: String) -> String:
	match sayfa:
		"beyan":
			return "hafiza.bos.beyan"
		"soylenti":
			return "hafiza.bos.soylenti"
		"not":
			return "hafiza.bos.not"
		"haber":
			return "hafiza.bos.haber"
		_:
			return "hafiza.bos.karar"


func oyuncu_yuzu(metin: String) -> String:
	var sonuc := metin.replace("DIY-", "").replace("HFZ-", "")
	return sonuc.strip_edges()


func baslik_metni(ad: String, gece: int) -> String:
	var gece_kalibi := tr("hafiza.satir.gece")
	if gece_kalibi.is_empty() or gece_kalibi == "hafiza.satir.gece":
		gece_kalibi = "%d. gece"
	var gece_yazi := "" if gece < 0 else gece_kalibi % gece
	var kalip := tr("hafiza.satir.baslik")
	if kalip.is_empty() or kalip == "hafiza.satir.baslik":
		kalip = "%s — %s"
	return kalip % [oyuncu_yuzu(ad), gece_yazi]


func hata_ayiklama_ekle(satir: Dictionary) -> int:
	_debug_satirlar.append(satir.duplicate(true))
	return 1


func hata_ayiklama_sayisi() -> int:
	return _debug_satirlar.size()


func satir_goruldu(kimlik: String) -> void:
	var temiz := kimlik.strip_edges()
	if temiz.is_empty() or okunan.has(temiz):
		return
	okunan.append(temiz)


func soluk_mu(ayar_acik: bool, kimlik: String) -> bool:
	return ayar_acik and okunan.has(kimlik)


func soluk_sayisi(ayar_acik: bool, satirlar: Array) -> int:
	var n := 0
	for satir in satirlar:
		if satir is Dictionary and soluk_mu(ayar_acik, String((satir as Dictionary).get("id", ""))):
			n += 1
	return n


func sirala(satirlar: Array) -> Array:
	var kopya: Array = satirlar.duplicate(true)
	kopya.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int(a.get("gece", -1)) > int(b.get("gece", -1))
	)
	return kopya


func suz(satirlar: Array, kisi: String) -> Array:
	var aranan := kisi.strip_edges()
	if aranan.is_empty():
		return satirlar.duplicate(true)
	var hedef := aranan.to_lower()
	var sonuc: Array = []
	for satir in satirlar:
		if not satir is Dictionary:
			continue
		var kayit: Dictionary = satir
		var ad := String(kayit.get("ad", "")).to_lower()
		var kim := String(kayit.get("kisi", "")).to_lower()
		if ad == hedef or kim == hedef:
			sonuc.append(kayit)
	return sonuc


## Yalniz hangi satirlarin goruldugu. Satir govdesi kaynak sistemde kalir.
func kaydet(hedef: Dictionary) -> Dictionary:
	var mevcut: Variant = hedef.get("hafiza", {})
	var hafiza: Dictionary = (mevcut as Dictionary).duplicate(true) if mevcut is Dictionary else {}
	hafiza["okunan"] = okunan.duplicate()
	hedef["hafiza"] = hafiza
	return hedef


## Eski kayitta alan yoksa bos sayilir, oyun cokmez.
func yukle(kaynak: Variant) -> bool:
	okunan.clear()
	if not kaynak is Dictionary:
		return true
	var hafiza: Variant = (kaynak as Dictionary).get("hafiza", null)
	if not hafiza is Dictionary:
		return true
	var liste: Variant = (hafiza as Dictionary).get("okunan", null)
	if liste is Array:
		for oge in liste as Array:
			satir_goruldu(String(oge))
	return true


func oku(kaynak: Dictionary) -> Dictionary:
	var karar := _karar_sayfasi(kaynak)
	var beyan := sirala(_benzersiz(_beyan_sayfasi(kaynak)))
	var soylenti := sirala(_soylenti_sayfasi(kaynak))
	var notlar := _not_sayfasi(kaynak)
	var haber := haber_sayfasi(kaynak)
	var sayfalar := SAYFALAR.duplicate()
	if not haber.is_empty(): sayfalar.append("haber")
	return {
		"sayfa_sayisi": sayfalar.size(),
		"sayfalar": sayfalar,
		"karar": karar,
		"beyan": beyan,
		"soylenti": soylenti,
		"not": notlar,
		"haber": haber,
		"yazim": yazim_sayisi,
		"sabah_kopyasi": 0,
		"sabah_acilisi": sabah_evresinde_acilir_mi(),
	}


## OMR-38: Haberci ağının `bekleyen` listesi hafıza defterinin "Haber" sayfasına geçer; `azami_metin` sınırı korunur.
func haber_sayfasi(kaynak: Variant) -> Array:
	var veri: Variant = kaynak
	if kaynak is Dictionary and (kaynak as Dictionary).has("haberci_agi"):
		veri = (kaynak as Dictionary)["haberci_agi"]
	var okunan_ag := HaberciAgi.oku(veri)
	var bekleyen: Variant = okunan_ag.get("bekleyen", [])
	return (bekleyen as Array).duplicate(true) if bekleyen is Array else []


func _karar_sayfasi(kaynak: Dictionary) -> Array:
	var satirlar: Array = []
	for oge in _dizi(kaynak, "diy14"):
		if oge is Dictionary:
			satirlar.append(_karar_satiri(oge, "", "", ""))
	var durumlar := _sozluk(kaynak, "durumlar")
	for kisi_id in durumlar:
		var ham_kayit: Variant = durumlar[kisi_id]
		if not ham_kayit is Dictionary:
			continue
		var kayit: Dictionary = ham_kayit
		var kisi := String(kisi_id)
		var ad := _ad_al(kayit)
		var durum := String(kayit.get("durum", ""))
		for oge in _dizi_alan(kayit, "karar_gecmisi"):
			if oge is Dictionary and _hatirlanacak_mi(oge):
				satirlar.append(_karar_satiri(oge, kisi, ad, durum))
	for oge in _dizi(kaynak, "cas07"):
		if oge is Dictionary:
			satirlar.append(_hukum_satiri(oge))
	for oge in _dizi(kaynak, "hukumler"):
		if oge is Dictionary:
			satirlar.append(_hukum_satiri(oge))
	satirlar = _donus_uygula(satirlar, _dizi(kaynak, "dyl08"))
	satirlar = _donus_uygula(satirlar, _dizi(kaynak, "donusler"))
	for oge in _debug_satirlar:
		satirlar.append(_karar_satiri(oge, String(oge.get("kisi", "")), _ad_al(oge), String(oge.get("durum", ""))))
	satirlar = sirala(_benzersiz(satirlar))
	var sinir := tavan()
	if satirlar.size() > sinir:
		return satirlar.slice(0, sinir)
	return satirlar


func _beyan_sayfasi(kaynak: Dictionary) -> Array:
	var satirlar: Array = []
	for oge in _dizi(kaynak, "beyanlar"):
		if oge is Dictionary:
			satirlar.append(_beyan_satiri(oge, "", "", ""))
	var durumlar := _sozluk(kaynak, "durumlar")
	for kisi_id in durumlar:
		var ham_kayit: Variant = durumlar[kisi_id]
		if not ham_kayit is Dictionary:
			continue
		var kayit: Dictionary = ham_kayit
		var kisi := String(kisi_id)
		var ad := _ad_al(kayit)
		var durum := String(kayit.get("durum", ""))
		var liste: Array = _dizi_alan(kayit, "beyanlar")
		if liste.is_empty():
			liste = _dizi_alan(kayit, "beyan_defteri")
		for oge in liste:
			if oge is Dictionary:
				satirlar.append(_beyan_satiri(oge, kisi, ad, durum))
	return satirlar


func _soylenti_sayfasi(kaynak: Dictionary) -> Array:
	var ham: Array = []
	if kaynak.has("soylenti_agi"):
		var ag: Variant = kaynak["soylenti_agi"]
		if ag is Array:
			ham = ag
		elif ag is Dictionary and (ag as Dictionary).get("kayitlar") is Array:
			ham = (ag as Dictionary)["kayitlar"]
	elif kaynak.get("soylenti") is Array:
		ham = kaynak["soylenti"]
	var satirlar: Array = []
	for oge in ham:
		if oge is Dictionary:
			satirlar.append(_soylenti_satiri(oge))
	return satirlar


func _not_sayfasi(kaynak: Dictionary) -> Array:
	var kimlikler: Array[String] = IpucuKaydi.durum_coz(kaynak, false)
	var baslangic := maxi(kimlikler.size() - NOT_SINIRI, 0)
	var satirlar: Array = []
	for i in range(kimlikler.size() - 1, baslangic - 1, -1):
		var kimlik := kimlikler[i]
		satirlar.append({
			"id": kimlik,
			"sayfa": "not",
			"metin_anahtari": oyuncu_yuzu(kimlik),
			"baslik_anahtari": "hafiza.satir.baslik",
			"baslik": oyuncu_yuzu(kimlik),
			"gece": -1,
			"ad": "",
			"kisi": "",
			"govde_anahtari": oyuncu_yuzu(kimlik),
		})
	var son_veri := son_kaydi_oku(kaynak)
	var nihai := String(son_veri.get("nihai", "")).strip_edges()
	if not nihai.is_empty():
		var son_soz := _sozluk(kaynak, "son")
		var baslik := String(son_soz.get("baslik", nihai)).strip_edges()
		if baslik.is_empty():
			baslik = nihai
		var epilog := String(son_veri.get("epilog", ""))
		if satirlar.size() >= NOT_SINIRI:
			satirlar = satirlar.slice(0, NOT_SINIRI - 1)
		satirlar.append({
			"id": "son:%s" % nihai,
			"sayfa": "not",
			"metin_anahtari": epilog,
			"baslik_anahtari": "hafiza.satir.baslik",
			"baslik": baslik,
			"gece": -1,
			"ad": "",
			"kisi": "",
			"govde_anahtari": epilog,
			"nihai": nihai,
			"epilog": epilog,
		})
	return satirlar


## OMR-17: Kaydedilmiş son ve epilog bilgisini Bölüm 39 defterinden salt-okunur okur.
func son_kaydi_oku(kaynak: Dictionary) -> Dictionary:
	var nihai := String(SonKaydi.kayittan_nihai_al(kaynak))
	var epilog := SonKaydi.kayittan_epilog_al(kaynak)
	return {"nihai": nihai, "epilog": epilog}


func _karar_satiri(oge: Dictionary, kisi: String, ad: String, durum: String) -> Dictionary:
	var gece := int(oge.get("gece", oge.get("gun", -1)))
	var kim := kisi if not kisi.is_empty() else String(oge.get("kisi", ""))
	var ad_yazi := ad if not ad.is_empty() else _ad_al(oge)
	var kimlik := String(oge.get("id", "")).strip_edges()
	if kimlik.is_empty():
		kimlik = "karar:%s:%d:%s" % [kim, gece, String(oge.get("karar", ""))]
	var durum_yazi := durum if not durum.is_empty() else String(oge.get("durum", ""))
	var notu := oyuncu_yuzu(String(oge.get("not_anahtari", oge.get("metin_anahtari", ""))))
	if notu.is_empty():
		notu = NOT_ANAHTARI
	var satir := {
		"id": kimlik,
		"sayfa": "karar",
		"kisi": kim,
		"ad": ad_yazi,
		"gece": gece,
		"baslik_anahtari": "hafiza.satir.baslik",
		"gece_anahtari": "hafiza.satir.gece",
		"baslik": baslik_metni(ad_yazi, gece),
		"govde_anahtari": notu,
		"sonuc_anahtari": oyuncu_yuzu(String(oge.get("sonuc_anahtari", ""))),
		"durum_anahtari": "hafiza.durum.gitti" if _gitti_mi(durum_yazi) else "",
		"etiket": "",
	}
	var hat := String(oge.get("hat", oge.get("omr_hat", ""))).to_lower()
	if DIS_HATLAR.has(hat) or bool(oge.get("dis_hat", false)):
		satir["etiket"] = "hafiza.etiket.dis_hat"
	return satir


func _hukum_satiri(oge: Dictionary) -> Dictionary:
	var satir := _karar_satiri(oge, String(oge.get("kisi", oge.get("adli_id", ""))), _ad_al(oge), String(oge.get("durum", "")))
	satir["hukum"] = String(oge.get("hukum", oge.get("karar", "")))
	var govde := oyuncu_yuzu(String(oge.get("hukum_anahtari", "")))
	if govde.is_empty():
		govde = oyuncu_yuzu(String(satir["hukum"]))
	if not govde.is_empty():
		satir["govde_anahtari"] = govde
	return satir


func _donus_uygula(satirlar: Array, donusler: Array) -> Array:
	var indeks := {}
	for i in satirlar.size():
		indeks[String((satirlar[i] as Dictionary).get("id", ""))] = i
	for oge in donusler:
		if not oge is Dictionary:
			continue
		var kayit: Dictionary = oge
		var hedef := String(kayit.get("hedef", kayit.get("satir_id", ""))).strip_edges()
		if hedef.is_empty():
			hedef = String(kayit.get("id", ""))
		if indeks.has(hedef):
			var satir: Dictionary = satirlar[indeks[hedef]]
			var sonuc := oyuncu_yuzu(String(kayit.get("sonuc_anahtari", "")))
			if not sonuc.is_empty():
				satir["sonuc_anahtari"] = sonuc
			satirlar[indeks[hedef]] = satir
		else:
			var yeni := _karar_satiri(kayit, String(kayit.get("kisi", "")), _ad_al(kayit), String(kayit.get("durum", "")))
			var sonuc_yeni := oyuncu_yuzu(String(kayit.get("sonuc_anahtari", "")))
			if not sonuc_yeni.is_empty():
				yeni["sonuc_anahtari"] = sonuc_yeni
			indeks[String(yeni["id"])] = satirlar.size()
			satirlar.append(yeni)
	return satirlar


func _beyan_satiri(oge: Dictionary, kisi: String, ad: String, durum: String) -> Dictionary:
	var gece := int(oge.get("gece", -1))
	var kim := kisi if not kisi.is_empty() else String(oge.get("kisi", ""))
	var ad_yazi := ad if not ad.is_empty() else _ad_al(oge)
	var kimlik := String(oge.get("id", "")).strip_edges()
	if kimlik.is_empty():
		kimlik = "beyan:%s:%s:%d" % [kim, String(oge.get("soru_id", "")), gece]
	var celiski := bool(oge.get("celiski", false)) or not String(oge.get("celiski_cift", "")).is_empty()
	var durum_yazi := durum if not durum.is_empty() else String(oge.get("durum", ""))
	return {
		"id": kimlik,
		"sayfa": "beyan",
		"kisi": kim,
		"ad": ad_yazi,
		"gece": gece,
		"baslik_anahtari": "hafiza.satir.baslik",
		"baslik": baslik_metni(ad_yazi, gece),
		"govde_anahtari": oyuncu_yuzu(String(oge.get("metin_anahtari", ""))),
		"soru_id": String(oge.get("soru_id", "")),
		"celiski": celiski,
		"celiski_anahtari": "hafiza.etiket.celiski" if celiski else "",
		"curutuldu": bool(oge.get("curutuldu", false)),
		"durum_anahtari": "hafiza.durum.gitti" if _gitti_mi(durum_yazi) else "",
	}


func _soylenti_satiri(oge: Dictionary) -> Dictionary:
	var gece := int(oge.get("gece", -1))
	var kaynak_adi := String(oge.get("kaynak", ""))
	if bool(oge.get("es", false)) and kaynak_adi.is_empty():
		kaynak_adi = "es"
	var ad := _ad_al(oge) if oge.has("ad") else kaynak_adi
	var kimlik := String(oge.get("id", "")).strip_edges()
	if kimlik.is_empty():
		kimlik = "soylenti:%s:%d:%s" % [kaynak_adi, gece, String(oge.get("olay", ""))]
	return {
		"id": kimlik,
		"sayfa": "soylenti",
		"kisi": String(oge.get("kisi", kaynak_adi)),
		"ad": ad,
		"gece": gece,
		"baslik_anahtari": "hafiza.satir.baslik",
		"baslik": baslik_metni(ad, gece),
		"olay_anahtari": oyuncu_yuzu(String(oge.get("olay", oge.get("olay_anahtari", "")))),
		"kaynak": kaynak_adi,
		"kademe_anahtari": _kademe_anahtari(String(oge.get("kademe", ""))),
		"dogrulandi": bool(oge.get("dogrulandi", false)),
		"es": kaynak_adi == "es" or bool(oge.get("es", false)),
	}


func _kademe_anahtari(kademe: String) -> String:
	match kademe.strip_edges().to_lower():
		"birkac", "birkaç":
			return "hafiza.kademe.birkac"
		"yari_koy", "yari koy", "yarı köy":
			return "hafiza.kademe.yari_koy"
		"herkes":
			return "hafiza.kademe.herkes"
		_:
			return ""


func _hatirlanacak_mi(oge: Dictionary) -> bool:
	return bool(oge.get("hatirlanacak", false)) or bool(oge.get("diy14", false))


func _gitti_mi(durum: String) -> bool:
	return GITTI_DURUMLARI.has(durum)


func _ad_al(kayit: Dictionary) -> String:
	if kayit.has("ad"):
		return String(kayit.get("ad", ""))
	if kayit.has("ad_anahtari"):
		return String(kayit.get("ad_anahtari", ""))
	return ""


func _dizi(kaynak: Dictionary, anahtar: String) -> Array:
	var ham: Variant = kaynak.get(anahtar, [])
	return ham if ham is Array else []


func _dizi_alan(kayit: Dictionary, anahtar: String) -> Array:
	var ham: Variant = kayit.get(anahtar, [])
	return ham if ham is Array else []


func _sozluk(kaynak: Dictionary, anahtar: String) -> Dictionary:
	var ham: Variant = kaynak.get(anahtar, {})
	return ham if ham is Dictionary else {}


func _benzersiz(satirlar: Array) -> Array:
	var gorulen := {}
	var sonuc: Array = []
	for satir in satirlar:
		if not satir is Dictionary:
			continue
		var kimlik := String((satir as Dictionary).get("id", ""))
		if gorulen.has(kimlik):
			continue
		gorulen[kimlik] = true
		sonuc.append(satir)
	return sonuc
