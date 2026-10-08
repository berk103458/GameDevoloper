## MEV-10: kış ağıl baskını tek gerçek geceye bağlıdır; ikinci hayvan/ekonomi modeli yok.
class_name KurtBaskini
extends RefCounted
static var AYAR: Dictionary = preload("res://data/kurt_baskini.json").data
const META := &"kurt_baskini_son_gece"
## Yaşayan köyün hazır ağılları kararlı sırada; inşaat ve sıcak hava hariç.
static func agillar(y: KoyYonetimi) -> Array[KoyBinasi]:
	var r: Array[KoyBinasi] = []
	if y.son != "" or y.nufus() == 0 or not y.kis_mi(): return r
	for b in y.binalar:
		if CobanSurusu.hazir(b): r.append(b)
	r.sort_custom(func(a: KoyBinasi, b: KoyBinasi) -> bool: return a.id < b.id)
	return r
## Her etkin yerel muhafız bir ağılı korur; borç/uyku/isyan/dış görev mevcut API'den.
static func korunan(y: KoyYonetimi, b: KoyBinasi) -> bool:
	var r := agillar(y)
	return r.has(b) and r.find(b) < y.etkin_muhafiz_sayisi()
## Mevcut devriye/A* ağıl çevresine de uğrar; ayrı nöbetçi üretilmez.
static func duraklar(y: KoyYonetimi) -> Array[Dictionary]:
	var r: Array[Dictionary] = []
	for b in agillar(y): r.append({"bina": b, "ad": "Ağılda kurt nöbeti"})
	return r
## Bozuk/eski optional gece makbuzu tekrar koruması yaratmaz.
static func oku(v: Variant) -> int:
	if (not v is int and not v is float) or not is_finite(float(v)) or float(v) != floor(float(v)) or float(v) < -1 or float(v) > 1000000000: return -1
	return int(v)
## Gecede tek deneme. Korunmayan sürü için aynı ambardan yemle uzaklaştırma; eksik yemde moral kaybı.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> int:
	var r := agillar(y)
	if r.is_empty() or oku(y.get_meta(META, -1)) == y.gun: return 0
	y.set_meta(META, y.gun)
	var hedef: KoyBinasi
	for b in r:
		if not korunan(y, b):
			hedef = b
			break
	if hedef == null:
		olaylar.append({"anahtar": "Meşaleli muhafız nöbeti kurtları ağıldan uzak tuttu."})
		return 0
	if y._rng.randi_range(1, 100) > int(AYAR.risk_yuzde): return 0
	var gereken := maxi(0, int(AYAR.yem_gida))
	var yem := mini(gereken, y.kaynaklar.miktar("gida"))
	y.kaynaklar.azalt("gida", yem)
	if yem < gereken:
		for k in y.koylular: k.moral = maxi(0, k.moral - (gereken - yem))
	olaylar.append({"anahtar": "Aç kurtlar ağıla (#%d) saldırdı; sürüyü korumak için %d erzak yemle uzaklaştırıldı.", "deger": [hedef.id, yem]})
	return yem
