## Köyün tarlaları: çiftçi sayısına göre açılan parseller; her birine bir ürün ekilir, geceler geçtikçe
## büyür, olgunlaşınca hasat ambara gider. Olaylar büyümeyi hızlandırır, geciktirir ya da verimi düşürür.
## Kurallar: design/gdd/tarla-ve-urunler.md
class_name Tarlalar
extends RefCounted

## Her parsel: {bitki: "" (boş) ya da ürün id, gun: büyüdüğü gece, carpan: verim çarpanı}
var parseller: Array[Dictionary] = []


## Parsel sayısını çiftçi sayısına göre ayarlar: ceil(çiftçi / başına), en çok `azami`.
## Azalırsa sondaki parseller (ekinleriyle) kaybolur.
func alan_guncelle(ciftci: int, basina: int, azami: int) -> void:
	var hedef := mini(azami, ceili(ciftci / float(maxi(1, basina))))
	while parseller.size() < hedef:
		parseller.append({"bitki": "", "gun": 0, "carpan": 1.0})
	while parseller.size() > hedef:
		parseller.pop_back()


func bos_sayisi() -> int:
	var n := 0
	for p in parseller:
		if p["bitki"] == "":
			n += 1
	return n


func ekili_sayisi() -> int:
	return parseller.size() - bos_sayisi()


## İlk boş parsele ürün eker. Döner: ekildi mi.
func ek(bitki: String) -> bool:
	for p in parseller:
		if p["bitki"] == "":
			p["bitki"] = bitki
			p["gun"] = 0
			p["carpan"] = 1.0
			return true
	return false


## Bir gece geçer: ekililer büyür; olgunlaşanlar hasat edilir.
## `sureler`/`verimler`: ürün id → gece / ürün. Döner: [{bitki, verim}] (hasatlar).
func gece(sureler: Dictionary, verimler: Dictionary) -> Array[Dictionary]:
	var hasat: Array[Dictionary] = []
	for p in parseller:
		if p["bitki"] == "":
			continue
		p["gun"] = int(p["gun"]) + 1
		if int(p["gun"]) >= int(sureler.get(p["bitki"], 1)):
			hasat.append({"bitki": p["bitki"], "verim": roundi(int(verimler.get(p["bitki"], 0)) * float(p["carpan"]))})
			p["bitki"] = ""
			p["gun"] = 0
			p["carpan"] = 1.0
	return hasat


## Olay: ekililerin büyümesine ek (negatif = gecikme; en az 0).
func gun_ekle(n: int) -> void:
	for p in parseller:
		if p["bitki"] != "":
			p["gun"] = maxi(0, int(p["gun"]) + n)


## Olay: ekililerin verimini çarpar (çekirge 0.5 gibi).
func verim_carp(x: float) -> void:
	for p in parseller:
		if p["bitki"] != "":
			p["carpan"] = float(p["carpan"]) * x


## Olay: henüz `esik` geceden genç ekinler ölür (erken don). Döner: ölen parsel sayısı.
func genc_yok_et(esik: int) -> int:
	var n := 0
	for p in parseller:
		if p["bitki"] != "" and int(p["gun"]) <= esik:
			p["bitki"] = ""
			p["gun"] = 0
			p["carpan"] = 1.0
			n += 1
	return n


## Görsel için olgunluk (0..1).
static func olgunluk(p: Dictionary, sureler: Dictionary) -> float:
	if p["bitki"] == "":
		return 0.0
	return clampf(float(p["gun"]) / maxf(1.0, float(sureler.get(p["bitki"], 1))), 0.0, 1.0)


func kaydet() -> Array:
	return parseller.duplicate(true)


func yukle(veri: Array) -> void:
	parseller.clear()
	for p in veri:
		parseller.append({"bitki": String(p.get("bitki", "")), "gun": int(p.get("gun", 0)), "carpan": float(p.get("carpan", 1.0))})
