## BUG-21: sınırlı kazılabilir kaynak; yapı kataloğuna ikinci ocak eklemez.
class_name TasYatagi
extends RefCounted

const IS_YERI := -3
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/tas_yatagi.json"))
var toplam := 0
var kalan := 0
var hucre := Vector2i(-1, -1)
var kurtarici_sayisi := 0
var son_gece := -1
var son_sabah := -1
var rng := RandomNumberGenerator.new()

static func yeni(y: KoyYonetimi, tohum: int) -> TasYatagi:
	var t := TasYatagi.new()
	t.rng.seed = tohum
	t.yerlestir(y, int(AYAR.baslangic_tas), true)
	return t

## Yatak yol/meydan/arazi/yapı üstüne düşmez. Başlangıç yalnız köy kenarındadır.
func yerlestir(y: KoyYonetimi, adet: int, kenar: bool = false) -> bool:
	var boslar: Array[Vector2i] = []
	for cy in y.izgara.boyut.y:
		for cx in y.izgara.boyut.x:
			var h := Vector2i(cx, cy)
			if kenar and cx != 0 and cy != 0 and cx != y.izgara.boyut.x - 1 and cy != y.izgara.boyut.y - 1: continue
			if y.izgara.bos(h): boslar.append(h)
	if boslar.is_empty(): return false # Ertelemede RNG ve sayaç da değişmez.
	y.izgara.kaldir(IS_YERI)
	hucre = boslar[rng.randi_range(0, boslar.size() - 1)]
	toplam = adet
	kalan = adet
	y.izgara.yerlestir(IS_YERI, [hucre])
	return true

func bilgi() -> String:
	return TranslationServer.translate("koy.tas_yatagi.bilgi") % [toplam, kalan]

static func uygun(y: KoyYonetimi, k: Koylu) -> bool:
	return k != null and k.yas_grubu == &"yetiskin" and YasRolleri.fiziksel(k, "tas_ocagi") and CirakEgitimi.saglam(k) and not KarantinaYoneticisi.aktif(k) and not KervanKorumasi.disarida(y, k.id) and not IsKazalari.uyuyor(k) and not IsMemnuniyeti.isyanci(k, y)

static func ata(y: KoyYonetimi, id: int) -> bool:
	var k := y.koylu(id)
	if y.tas_yatagi == null or y.tas_yatagi.kalan <= 0 or y.son != "" or not uygun(y, k): return false
	GeciciIsler.birak(y,k)
	k.is_yeri = IS_YERI
	return true

## Bir gece bir kez; kapasiteye girmeyen taş yatakta kalır, üretim kaybolmaz.
func gece(y: KoyYonetimi, uretim: Dictionary, olaylar: Array[Dictionary], calismalar: Dictionary) -> void:
	if son_gece == y.gun: return
	son_gece = y.gun
	var adet := 0
	for k in y.calisanlar(IS_YERI):
		if kalan <= 0: break
		if not uygun(y, k): continue
		var giren := y.kaynaklar.ekle("tas", mini(kalan, GeciciIsler.tas_verimi(k,y,int(AYAR.isci_gunluk_tas))))
		GeciciIsler.tas_makbuzu(y,k,giren)
		kalan -= giren
		adet += giren
		if giren > 0: calismalar[k.id] = IS_YERI
	if adet > 0:
		uretim["tas"] = int(uretim.get("tas", 0)) + adet
		olaylar.append({"anahtar": "koy.tas_yatagi.kazi", "deger": [adet, kalan]})
	if kalan == 0:
		y.izgara.kaldir(IS_YERI)
		for k in y.calisanlar(IS_YERI): k.is_yeri = KoyYonetimi.BOSTA

func kaydet() -> Dictionary:
	return {"toplam": toplam, "kalan": kalan, "hucre": [hucre.x, hucre.y], "kurtarici_sayisi": kurtarici_sayisi, "son_gece": son_gece, "son_sabah": son_sabah, "rng": str(rng.state)}

## Optional alan yok/null/bozuksa yatak yoktur. Eski kayda yeni yatak eklenmez.
static func yukle(y: KoyYonetimi, v: Variant) -> void:
	y.izgara.kaldir(IS_YERI)
	y.tas_yatagi = null
	if v is Dictionary:
		var h: Variant = v.get("hucre")
		var gecerli: bool = h is Array and h.size() == 2 and _tam(h[0], 0, y.izgara.boyut.x - 1) and _tam(h[1], 0, y.izgara.boyut.y - 1)
		gecerli = gecerli and _tam(v.get("toplam"), 1, maxi(int(AYAR.baslangic_tas), int(AYAR.kurtarici_tas))) and _tam(v.get("kalan"), 0, int(v.get("toplam", 0)))
		gecerli = gecerli and _tam(v.get("kurtarici_sayisi"), 0, int(AYAR.kurtarici_azami)) and _tam(v.get("son_gece"), -1, y.gun) and _tam(v.get("son_sabah"), -1, y.gun)
		gecerli = gecerli and v.get("rng") is String and String(v.rng).is_valid_int()
		if gecerli:
			var t := TasYatagi.new()
			t.toplam = int(v.toplam)
			t.kalan = int(v.kalan)
			t.hucre = Vector2i(int(h[0]), int(h[1]))
			t.kurtarici_sayisi = int(v.kurtarici_sayisi)
			t.son_gece = int(v.son_gece)
			t.son_sabah = int(v.son_sabah)
			t.rng.state = String(v.rng).to_int()
			# Dolu hücreyi ezme; tükenmiş yatak başka yapıyla örtüşebilir.
			if t.kalan == 0 or y.izgara.bos(t.hucre):
				y.tas_yatagi = t
				if t.kalan > 0: y.izgara.yerlestir(IS_YERI, [t.hucre])
	if y.tas_yatagi == null or y.tas_yatagi.kalan == 0:
		for k in y.calisanlar(IS_YERI): k.is_yeri = KoyYonetimi.BOSTA

static func _tam(v: Variant, alt: int, ust: int) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and floor(float(v)) == float(v) and float(v) >= alt and float(v) <= ust
