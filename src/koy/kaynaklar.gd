## Tek ortak ambar (design/gdd/koy-yonetimi.md, 4.1–4.2): tüm ürünler tek envantere yazılır; toplam stok kapasiteyi geçemez.
class_name Kaynaklar
extends RefCounted

## KRI-06: yalnız gerçekten ambara giren erzak kıtlık serisini keser.
signal erzak_geldi

## Ambarın tuttuğu türler (sıra arayüzdeki sıradır).
const TURLER: Array[String] = ["gida", "odun", "tas", "kereste", "alet", "kurk", "demir", "tomruk", "bugday", "un", "kirec", "harc", "cevher", "civi", "tirpan", "balta", "afyon", "sargi", "kece", "kumas", "zirh", "yay", "kalkan", "su", "saman", "ilac"]

var stok: Dictionary = {}
var bakim: Dictionary = {"artik": {}, "tasma": {}, "son_gece": -1}
var kapasite: int = 150:
	set(v):
		kapasite = maxi(0, v)
		AmbarBakimi.sinirla(self)


func _init(kapasite_: int = 150, baslangic: Dictionary = {}) -> void:
	kapasite = kapasite_
	for t in TURLER:
		stok[t] = maxi(0, int(baslangic.get(t, 0)))
	AmbarBakimi.sinirla(self)


func miktar(tur: String) -> int:
	return int(stok.get(tur, 0))


func toplam() -> int:
	var t := 0
	for k in stok:
		t += int(stok[k])
	return t


func bos_yer() -> int:
	return maxi(0, kapasite - toplam())


func dolu_mu() -> bool:
	return bos_yer() == 0


## Ambara ekler; yer kalmadıysa sığan kadarını. Döner: eklenen miktar.
func ekle(tur: String, adet: int) -> int:
	var sigan := mini(maxi(adet, 0), bos_yer())
	stok[tur] = miktar(tur) + sigan
	if tur == "gida" and sigan > 0: erzak_geldi.emit()
	return sigan


## `maliyet` ({tür: adet}) ambarda var mı.
func yeterli(maliyet: Dictionary) -> bool:
	for t in maliyet:
		if miktar(t) < int(maliyet[t]):
			return false
	return true


## Maliyeti düşer; yetmezse hiçbir şeye dokunmaz. Döner: düşüldü mü.
func harca(maliyet: Dictionary) -> bool:
	if not yeterli(maliyet):
		return false
	for t in maliyet:
		stok[t] = miktar(t) - int(maliyet[t])
	return true


## Olabildiği kadar düşer (çalınma, baskın, tüketim). Döner: düşülen.
func azalt(tur: String, adet: int) -> int:
	var d := mini(miktar(tur), maxi(adet, 0))
	stok[tur] = miktar(tur) - d
	return d


func kaydet() -> Dictionary:
	return {"stok": stok.duplicate(), "kapasite": kapasite, "bakim": bakim.duplicate(true)}


static func kayittan(v: Dictionary) -> Kaynaklar:
	var k := Kaynaklar.new(int(v.get("kapasite", 150)))
	k.bakim = AmbarBakimi.oku(v.get("bakim"))
	var s: Dictionary = v.get("stok", {}) if v.get("stok", {}) is Dictionary else {}
	for t in TURLER:
		var n: Variant = s.get(t, 0)
		k.stok[t] = clampi(int(n), 0, 1000000000) if (n is int or n is float) and is_finite(float(n)) else 0
	AmbarBakimi.sinirla(k)
	return k
