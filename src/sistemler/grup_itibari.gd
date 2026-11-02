## DIY-12: Grup itibari — Turkmen, Rum, Ahi, koylu, tuccar, asker.
## Alti grubun her birinin itibari -10 ile +10 arasindadir.
## Bir ziyaret yalniz karakterin birincil grubuna yazar; Turkmen reti Rum degerini degistirmez.
## Sinirin disina tasan yazim -10 veya +10'da kesilir ve kayitta "kesildi" diye durur.
## Yedinci grup adi reddedilir. Kayit anahtari kalp veya romans olamaz.
class_name GrupItibari
extends RefCounted


const VERI_YOLU := "res://data/gruplar.json"
const ASGARI_ITIBAR := -10
const AZAMI_ITIBAR := 10
const VARSAYILAN_GRUP := "koylu"

const GECERLI_GRUPLAR := [
	"turkmen",
	"rum",
	"ahi",
	"koylu",
	"tuccar",
	"asker",
]

const GRUP_ADLARI := {
	"turkmen": "Türkmen",
	"rum": "Rum",
	"ahi": "Ahi",
	"koylu": "Köylü",
	"tuccar": "Tüccar",
	"asker": "Asker",
}

var _puanlar: Dictionary = {}
var _yazim_kayitlari: Array[Dictionary] = []
var _aktif_ziyaret_yazildi: bool = false


func _init() -> void:
	sifirla()


## Tum grup itibarlarini baslangic degerine (0) sifirlar.
func sifirla() -> void:
	_puanlar.clear()
	for g in GECERLI_GRUPLAR:
		_puanlar[g] = 0
	_yazim_kayitlari.clear()
	_aktif_ziyaret_yazildi = false


## Yeni bir kapi ziyareti basladiginda tek-yazim kilidini acar.
func ziyaret_baslat() -> void:
	_aktif_ziyaret_yazildi = false


## Grup kimligini normallestirir (Turkce karakterleri ASCII karsiligina cevirir).
## Bos ise varsayilan grup ("koylu") doner (uyari degildir).
static func norm_grup(ham: Variant) -> String:
	if ham is Array:
		var dizi: Array = ham
		if dizi.is_empty():
			return VARSAYILAN_GRUP
		return norm_grup(dizi[0])
	if ham is Dictionary:
		var sozluk: Dictionary = ham
		if sozluk.has("birincil_grup"):
			return norm_grup(sozluk["birincil_grup"])
		if sozluk.has("grup"):
			return norm_grup(sozluk["grup"])
		if sozluk.has("gruplar") and sozluk["gruplar"] is Array and not (sozluk["gruplar"] as Array).is_empty():
			return norm_grup((sozluk["gruplar"] as Array)[0])
		return VARSAYILAN_GRUP

	var s := String(ham).strip_edges().to_lower()
	if s.is_empty():
		return VARSAYILAN_GRUP
	s = s.replace("ü", "u").replace("ö", "o").replace("ı", "i").replace("ş", "s").replace("ç", "c").replace("ğ", "g")
	return s


## Grup kimliginin 6 gecerli gruptan biri olup olmadigini denetler.
## Yedinci grup adi ve "kalp" / "romans" anahtarlari reddedilir.
static func gecerli_grup_mu(ham: Variant) -> bool:
	var s := String(ham).strip_edges().to_lower()
	if s == "kalp" or s == "romans":
		return false
	var norm := norm_grup(ham)
	if norm == "kalp" or norm == "romans":
		return false
	return norm in GECERLI_GRUPLAR


## `data/gruplar.json` dosyasini veya verilen sozlugu dogrular.
static func veri_dogrula(veri: Dictionary = {}) -> Array[String]:
	var kaynak := veri
	if kaynak.is_empty():
		var okunan: Variant = JSON.parse_string(FileAccess.get_file_as_string(VERI_YOLU))
		if okunan is Dictionary:
			kaynak = okunan
		else:
			return ["gruplar_json_okunamadi"]

	var hatalar: Array[String] = []
	var ham_metin := JSON.stringify(kaynak).to_lower()
	if ham_metin.contains("\"kalp\"") or ham_metin.contains("\"romans\""):
		hatalar.append("yasak_anahtar_kalp_veya_romans")

	var liste: Variant = kaynak.get("gruplar", [])
	if not (liste is Array):
		hatalar.append("gruplar_dizi_degil")
		return hatalar

	var gruplar_dizi: Array = liste
	if gruplar_dizi.size() != GECERLI_GRUPLAR.size():
		hatalar.append("grup_sayisi_hatali:%d" % gruplar_dizi.size())

	var gorulen: Dictionary = {}
	for oge in gruplar_dizi:
		if not (oge is Dictionary):
			hatalar.append("grup_ogesi_sozluk_degil")
			continue
		var d: Dictionary = oge
		var id := String(d.get("id", "")).strip_edges().to_lower()
		if id == "kalp" or id == "romans":
			hatalar.append("yasak_grup_id:%s" % id)
		elif not (id in GECERLI_GRUPLAR):
			hatalar.append("yedinci_veya_gecersiz_grup:%s" % id)
		elif gorulen.has(id):
			hatalar.append("tekrarlanan_grup:%s" % id)
		else:
			gorulen[id] = true
	return hatalar


## Belirtilen grubun guncel itibar puanini (-10..+10) doner.
func deger(grup: Variant) -> int:
	var g := norm_grup(grup)
	if not (g in GECERLI_GRUPLAR):
		return 0
	return int(_puanlar.get(g, 0))


## Tum gruplarin itibar sozlugunun kopyasini doner.
func tum_degerler() -> Dictionary:
	return _puanlar.duplicate(true)


## Yazim denemelerinin gecmisini doner (kesilen denemeler `kesildi: true` ve `durum: "kesildi"` icerir).
func yazim_kayitlari() -> Array[Dictionary]:
	return _yazim_kayitlari.duplicate(true)


## Bir ziyarette karakterin birincil grubuna itibar degisimi uygular.
## - Cift gruplu kiside yalniz birincil gruba yazar; ayni ziyarette ikinci gruba yazilmaz.
## - Grupsuz karakter koylu sayilir (uyari uretmez).
## - Sinir disina tasan yazim -10 veya +10'da kesilir ve kayitta `durum: "kesildi"` olarak durur.
func uygula(karakter_veya_grup: Variant, delta: int, tek_ziyaret_kilidi: bool = false) -> Dictionary:
	if tek_ziyaret_kilidi and _aktif_ziyaret_yazildi:
		return {
			"olur": false,
			"hata": "ayni_ziyarette_ikinci_grup_yazimi_yasak",
			"yazilan_grup_sayisi": 0,
		}

	# Ham girdi yedinci grup veya kalp/romans ise reddet
	if karakter_veya_grup is String or karakter_veya_grup is StringName:
		var ham_str := String(karakter_veya_grup).strip_edges()
		if not ham_str.is_empty() and not gecerli_grup_mu(ham_str):
			return {
				"olur": false,
				"hata": "gecersiz_grup:%s" % ham_str,
				"yazilan_grup_sayisi": 0,
			}
	elif karakter_veya_grup is Dictionary:
		var d: Dictionary = karakter_veya_grup
		for k in d.keys():
			var ks := String(k).to_lower()
			if ks == "kalp" or ks == "romans":
				return {
					"olur": false,
					"hata": "yasak_anahtar:%s" % ks,
					"yazilan_grup_sayisi": 0,
				}
		var ham_birincil := String(d.get("birincil_grup", d.get("grup", ""))).strip_edges()
		if not ham_birincil.is_empty() and not gecerli_grup_mu(ham_birincil):
			return {
				"olur": false,
				"hata": "gecersiz_grup:%s" % ham_birincil,
				"yazilan_grup_sayisi": 0,
			}

	var hedef_grup := norm_grup(karakter_veya_grup)
	var onceki := int(_puanlar.get(hedef_grup, 0))
	var ham_yeni := onceki + delta
	var yeni := clampi(ham_yeni, ASGARI_ITIBAR, AZAMI_ITIBAR)
	var kesildi := (ham_yeni != yeni)
	_puanlar[hedef_grup] = yeni
	if tek_ziyaret_kilidi:
		_aktif_ziyaret_yazildi = true

	var kayit_satiri := {
		"grup": hedef_grup,
		"onceki": onceki,
		"delta": delta,
		"uygulanan_delta": yeni - onceki,
		"yeni": yeni,
		"kesildi": kesildi,
		"durum": "kesildi" if kesildi else "uygulandi",
		"yazilan_grup_sayisi": 1,
	}
	_yazim_kayitlari.append(kayit_satiri)
	return {
		"olur": true,
		"grup": hedef_grup,
		"onceki": onceki,
		"yeni": yeni,
		"uygulanan_delta": yeni - onceki,
		"kesildi": kesildi,
		"durum": "kesildi" if kesildi else "uygulandi",
		"yazilan_grup_sayisi": 1,
	}


## Karar kimligine ("kabul", "ret", "rusvet", "kisla") gore karakterin birincil grubuna yazar.
## Bir ziyarette yazilan grup sayisi tam 1'dir.
func karar_uygula(karakter_veya_grup: Variant, karar: String, tek_ziyaret_kilidi: bool = true) -> Dictionary:
	var k := karar.strip_edges().to_lower()
	k = k.replace("ü", "u").replace("ş", "s").replace("ı", "i").replace("ç", "c").replace("ğ", "g").replace("ö", "o")
	var delta := 0
	match k:
		"kabul", "yardim":
			delta = 1
		"ret", "rusvet":
			delta = -1
		"ihbar":
			delta = -2
		_:
			delta = 0
	return uygula(karakter_veya_grup, delta, tek_ziyaret_kilidi)


## DIY-09 (SatirSecici) ve ZAR-04 (ZarDegistiricileri) icin soz baglamina grup itibarini yazar.
func baglama_yaz(baglam: Dictionary, karakter_veya_grup: Variant = "") -> Dictionary:
	var kopya := baglam.duplicate(true)
	var g_sozluk := tum_degerler()
	kopya["grup_itibari"] = g_sozluk
	var birincil := norm_grup(karakter_veya_grup)
	if birincil in GECERLI_GRUPLAR:
		kopya["birincil_grup"] = birincil
		kopya["grup_itibari_degeri"] = int(g_sozluk.get(birincil, 0))
	return kopya


## ZAR-04 zar degistiricisi icin uçtaki grup itibari etkisini (-1, 0, +1) doner.
func zar_etkisi(karakter_veya_grup: Variant) -> int:
	var puan := deger(karakter_veya_grup)
	if puan >= 7:
		return -1
	if puan <= -7:
		return 1
	return 0


## Kural 4: Koylu kartinda ve muhafiz odasinda gorunecek ozet verisi (yeni ekran acilmaz).
func koylu_karti_bilgisi(karakter_veya_grup: Variant) -> Dictionary:
	var g := norm_grup(karakter_veya_grup)
	var puan := deger(g)
	return {
		"grup": g,
		"ad": String(GRUP_ADLARI.get(g, "Köylü")),
		"itibar": puan,
	}


func oda_ozeti() -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	for g in GECERLI_GRUPLAR:
		sonuc.append({
			"id": g,
			"ad": String(GRUP_ADLARI.get(g, g)),
			"itibar": int(_puanlar.get(g, 0)),
		})
	return sonuc


## Kayit sozlugu uretir. "kalp" veya "romans" anahtari barindirmaz.
func kaydet() -> Dictionary:
	return {
		"puanlar": _puanlar.duplicate(true),
		"yazim_kayitlari": _yazim_kayitlari.duplicate(true),
	}


## Kayittan yukler. Yedinci grup veya "kalp"/"romans" anahtari varsa false doner.
func yukle(veri: Dictionary) -> bool:
	for ust_anahtar in veri.keys():
		var uk := String(ust_anahtar).to_lower()
		if uk == "kalp" or uk == "romans":
			return false

	var puanlar_ham: Variant = veri.get("puanlar", veri)
	if not (puanlar_ham is Dictionary):
		return false
	var p_sozluk: Dictionary = puanlar_ham
	for k in p_sozluk.keys():
		var ks := String(k).strip_edges().to_lower()
		if ks == "yazim_kayitlari":
			continue
		if ks == "kalp" or ks == "romans":
			return false
		if not (ks in GECERLI_GRUPLAR):
			return false

	sifirla()
	for g in GECERLI_GRUPLAR:
		if p_sozluk.has(g):
			_puanlar[g] = clampi(int(p_sozluk[g]), ASGARI_ITIBAR, AZAMI_ITIBAR)
	if veri.get("yazim_kayitlari") is Array:
		for kayit in veri["yazim_kayitlari"]:
			if kayit is Dictionary:
				_yazim_kayitlari.append((kayit as Dictionary).duplicate(true))
	return true
