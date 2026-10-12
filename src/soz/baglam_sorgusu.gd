## DIY-08: konusma basinda dunyanin durumu tek salt-okunur sozlukte toplanir.
## Sozluk ziyaret basinda bir kez kurulur; ziyaret icinde dikilen bina ayni konusmada gorunmez.
## Okudugu yoneticiler degismez: yalniz okuma yapar, ekonomiye/kasaya/salgina yazmaz.
class_name BaglamSorgusu
extends RefCounted


## Belgede tanimli alan listesinin tek kaynagi; dogrulayici bu dosyayla eslesmeyi sinar.
const ALAN_DOSYASI := "res://data/soz/baglam_alanlari.json"
## Isik/gorusu daraltan havalarin yaricap tablosu; mevcut kapi gorusu kaynagi yeniden yazilmaz.
const GORUS_DOSYASI := "res://data/kapi_gorusu.json"
## class_name'i olmayan moduller preload ile baglanir (mevcut duzen).
const KRIZ_KENETLENMESI = preload("res://src/koy/kriz_kenetlenmesi.gd")
const TEHDIT_TAKVIMI = preload("res://src/sistemler/tehdit_takvimi.gd")

var _sozluk: Dictionary = {}


## Belgedeki alan listesi (tek kaynak). Sozlukte eksik alan varsa dogrulayici hata verir.
static func alanlar() -> Array[String]:
	var r: Array[String] = []
	var v: Variant = JSON.parse_string(FileAccess.get_file_as_string(ALAN_DOSYASI))
	if v is Dictionary and v.get("alanlar") is Array:
		for a in v.alanlar:
			r.append(String(a))
	return r


## Sozlukte olup belgede olmayan ve belgede olup sozlukte olmayan alanlar.
## Bos liste = sozluk belgedeki butun alanlari tasir ve fazladan alan yoktur.
static func eksik_alanlar(sozluk: Dictionary) -> Array[String]:
	var r: Array[String] = []
	var beklenen := alanlar()
	for a in beklenen:
		if not sozluk.has(a):
			r.append(a)
	for a in sozluk.keys():
		if not (String(a) in beklenen):
			r.append(String(a))
	return r


## Ziyaret/sahne baslangici: sozlugu canli yoneticilerden bir kez kurar ve saklar.
## Oturum yoksa da doner; yoneticisi olmayan alan false/0 ile dolar, cokme olmaz.
func kur(o: Oturum, gelen: Gelen = null) -> Dictionary:
	_sozluk = _kur_sozluk(o, gelen)
	if not eksik_alanlar(_sozluk).is_empty():
		push_error("Baglam sozlugu alan listesine uymuyor: %s" % str(eksik_alanlar(_sozluk)))
	return _sozluk.duplicate(true)


## Kayitli sozlugun kopyasi. Donen degerin degistirilmesi saklanan sozlugu bozmaz.
func oku() -> Dictionary:
	return _sozluk.duplicate(true)


## Canli yoneticilerden yeniden kurar ve saklar; oku() ayni ziyaret icinde bunu kullanmaz.
func yenile(o: Oturum, gelen: Gelen = null) -> Dictionary:
	_sozluk = _kur_sozluk(o, gelen)
	return _sozluk.duplicate(true)


static func _kur_sozluk(o: Oturum, gelen: Gelen) -> Dictionary:
	var y := _yonetim(o)
	var mevsim_durum: Dictionary = MevsimYoneticisi.durum(y) if y != null else {}
	var hava := IklimDeneyi.hava(y) if y != null else "normal"
	var krizler: Array[String] = []
	if y != null:
		for t in KRIZ_KENETLENMESI.krizler(y):
			krizler.append(String(t))
	var terazi: Dictionary = _terazi(o)
	return {
		"gun": y.gun if y != null else 0,
		"mevsim": int(mevsim_durum.get("mevsim", 0)),
		"mevsim_adi": String(mevsim_durum.get("ad", "")),
		"hava": hava,
		"krizler": krizler,
		"bina": _binalar(y),
		"nufus": y.nufus() if y != null else 0,
		"terazi": int(terazi.get("denge", 0)),
		"itibar": String(terazi.get("unvan", "")),
		"onceki_ziyaret": _ziyaret(o, gelen),
		"dunya_olaylari": _dunya_olaylari(o, y),
		"yatak": _yatak(y),
		"salgin": _salgin(y),
		"tipi": hava == "kar_firtinasi",
		"isik": _isik(hava),
	}


static func _yonetim(o: Oturum) -> KoyYonetimi:
	return o.yonetim if o != null else null


static func _terazi(o: Oturum) -> Dictionary:
	return MuhafizTerazisi.durum(o) if o != null else {}


## Her bina turu icin var mi; olmayan bina false doner, kelime tahmini yoktur.
static func _binalar(y: KoyYonetimi) -> Dictionary:
	var r: Dictionary = {}
	if y == null:
		return r
	# Katalogdaki her tür önce false: olmayan bina anahtarı da false döner (.get gerekmez).
	if y.katalog != null:
		for tur in y.katalog.turler.keys():
			r[String(tur)] = false
	for b in y.binalar:
		r[String(b.tur)] = true
	return r


## Hazir yataklarin doluluk orani; yonetici yoksa 0.0 (cokme yok).
static func _yatak(y: KoyYonetimi) -> float:
	if y == null:
		return 0.0
	var kapasite := y.yatak_kapasitesi()
	if kapasite <= 0:
		return 0.0
	var dolu := 0
	for k in y.koylular:
		if k.ev >= 0:
			dolu += 1
	return clampf(float(dolu) / float(kapasite), 0.0, 1.0)


## Acik salgin bayragi: gercek hasta kisi veya kriz kenetlenmesi kaydi. Tahmin yoktur.
static func _salgin(y: KoyYonetimi) -> bool:
	if y == null:
		return false
	for k in y.koylular:
		if SaglikYoneticisi.hasta(k):
			return true
	return "salgin" in KRIZ_KENETLENMESI.krizler(y)


## Aktif dunya olaylari: tehdit takvimi acik mi ve gorulen olay kimlikleri.
## Ikinci olay motoru yoktur; mevcut okuma yuzeylerinden derlenir.
static func _dunya_olaylari(o: Oturum, y: KoyYonetimi) -> Dictionary:
	var r: Dictionary = {"tehdit_kapisi": false, "gorulenler": []}
	if o == null:
		return r
	r["tehdit_kapisi"] = TEHDIT_TAKVIMI.acik(y.gun) if y != null else false
	var gorulenler: Array[String] = []
	for id in o.gorulen_olaylar.keys():
		gorulenler.append(String(id))
	gorulenler.sort()
	r["gorulenler"] = gorulenler
	return r


## Ziyaret basindaki sayac (bu konusmayi sayar). Kayit yuklendiyse canli kadrodan okunur.
static func _ziyaret(o: Oturum, gelen: Gelen) -> int:
	if o == null or o.kadro == null or gelen == null or not gelen.adli:
		return 0
	var d: Variant = o.kadro.durumlar.get(gelen.id, {})
	if not d is Dictionary:
		return 0
	var v: Variant = d.get("ziyaret", 0)
	if not (v is int or v is float):
		return 0
	return int(v)


## Gorusu daraltan havalarin yaricapi; acik havada 0.0. Okuma; RNG veya kayit uretmez.
static func _isik(hava: String) -> float:
	var v: Variant = JSON.parse_string(FileAccess.get_file_as_string(GORUS_DOSYASI))
	if not v is Dictionary:
		return 0.0
	var n: Variant = v.get(hava, 0.0)
	if not (n is int or n is float) or not is_finite(float(n)) or float(n) < 0.0:
		return 0.0
	return clampf(float(n), 0.0, 8.0)
