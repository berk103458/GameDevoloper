## Köy ızgarası (design/gdd/koy-yonetimi.md, 6.1–6.3): hücre doluluğu, yollar ve yerleşim kuralı.
## Bir yapı yalnız boş hücrelere oturur ve kenarlarından biri, meydana bağlı bir yola (ya da meydana) değmelidir.
class_name Izgara
extends RefCounted

var boyut: Vector2i
var meydan: Rect2i
## Hücre → yapı kimliği.
var dolu: Dictionary = {}
## Yol hücreleri (anahtar kümesi).
var yollar: Dictionary = {}
## Geçilmez arazi (kaya, dere, ağaç).
var engeller: Dictionary = {}

const KOMSULAR: Array[Vector2i] = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]


func _init(boyut_: Vector2i, meydan_: Rect2i) -> void:
	boyut = boyut_
	meydan = meydan_
	# Kapıdan (güney kenarı) meydana bir patika ile başlanır.
	var x := meydan.position.x + meydan.size.x / 2
	for y in range(meydan.end.y, boyut.y):
		yollar[Vector2i(x, y)] = true


func icinde(h: Vector2i) -> bool:
	return h.x >= 0 and h.y >= 0 and h.x < boyut.x and h.y < boyut.y


func meydanda(h: Vector2i) -> bool:
	return meydan.has_point(h)


func bos(h: Vector2i) -> bool:
	return icinde(h) and not dolu.has(h) and not yollar.has(h) and not engeller.has(h) and not meydanda(h)


## Meydana yol üzerinden bağlı hücreler (meydan dahil).
func bagli_yollar() -> Dictionary:
	var gorulen := {}
	var kuyruk: Array[Vector2i] = []
	for y in range(meydan.position.y, meydan.end.y):
		for x in range(meydan.position.x, meydan.end.x):
			gorulen[Vector2i(x, y)] = true
			kuyruk.append(Vector2i(x, y))
	while not kuyruk.is_empty():
		var h: Vector2i = kuyruk.pop_back()
		for d in KOMSULAR:
			var n := h + d
			if yollar.has(n) and not gorulen.has(n):
				gorulen[n] = true
				kuyruk.append(n)
	return gorulen


## Yerleşim denetimi. Döner: {olur: bool, neden: String} (neden: `sinir`, `dolu`, `yol_yok` ya da boş).
func yerlesebilir(hucreler: Array[Vector2i]) -> Dictionary:
	for h in hucreler:
		if not icinde(h):
			return {"olur": false, "neden": "sinir"}
		if not bos(h):
			return {"olur": false, "neden": "dolu"}
	var bagli := bagli_yollar()
	for h in hucreler:
		for d in KOMSULAR:
			if bagli.has(h + d):
				return {"olur": true, "neden": ""}
	return {"olur": false, "neden": "yol_yok"}


func yerlestir(id: int, hucreler: Array[Vector2i]) -> void:
	for h in hucreler:
		dolu[h] = id


func kaldir(id: int) -> void:
	for h in dolu.keys():
		if dolu[h] == id:
			dolu.erase(h)


## Yol döşer: hücre boş olmalı ve bağlı bir yola/meydana değmeli.
func yol_kur(h: Vector2i) -> bool:
	if not bos(h):
		return false
	var bagli := bagli_yollar()
	for d in KOMSULAR:
		if bagli.has(h + d):
			yollar[h] = true
			return true
	return false


func kaydet() -> Dictionary:
	var y: Array = []
	for h in yollar:
		y.append([h.x, h.y])
	var e: Array = []
	for h in engeller:
		e.append([h.x, h.y])
	return {"yollar": y, "engeller": e}


func kayittan_yukle(v: Dictionary) -> void:
	yollar.clear()
	for h in v.get("yollar", []):
		yollar[Vector2i(int(h[0]), int(h[1]))] = true
	engeller.clear()
	for h in v.get("engeller", []):
		engeller[Vector2i(int(h[0]), int(h[1]))] = true
