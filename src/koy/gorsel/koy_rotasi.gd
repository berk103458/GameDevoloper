## Görsel köylü hareketi: dört komşulu A*, yapı ve arazi engelleri kapalı, yollar ucuz.
class_name KoyRotasi
extends RefCounted

var _ag := AStar3D.new()
var _izgara: Izgara
var _zemin_maliyeti := 1.0

## Doluluk değişince grafiği kurar. Ekonomi ve kayıt durumunu değiştirmez.
func kur(izgara: Izgara, zemin_maliyeti: float) -> void:
	_izgara = izgara
	_zemin_maliyeti = maxf(1.0, zemin_maliyeti)
	_ag.clear()
	for y in izgara.boyut.y:
		for x in izgara.boyut.x:
			var h := Vector2i(x, y)
			if not gecilir(h):
				continue
			var ucuz := izgara.yollar.has(h) or izgara.meydanda(h)
			_ag.add_point(_id(h), Vector3(x, 0, y), 1.0 if ucuz else _zemin_maliyeti)
	for id in _ag.get_point_ids():
		var h := _hucre(id)
		for d in [Vector2i.RIGHT, Vector2i.DOWN]:
			var n: Vector2i = h + d
			if gecilir(n):
				_ag.connect_points(id, _id(n))

## Hücre yapı veya geçilmez arazi ile kapalı mı?
func gecilir(h: Vector2i) -> bool:
	return _izgara.icinde(h) and not _izgara.dolu.has(h) and not _izgara.engeller.has(h)

## Hedefe tam yol; erişilemeyen veya kapalı hedef için boş dizi döner.
func yol(bas: Vector2i, son: Vector2i) -> Array[Vector2i]:
	var sonuc: Array[Vector2i] = []
	if not gecilir(bas) or not gecilir(son):
		return sonuc
	for id in _ag.get_id_path(_id(bas), _id(son)):
		sonuc.append(_hucre(id))
	return sonuc


## Yalnız bu sorguda duran kökleri ve ayrılmış varışları kapatır, yakın trafiği daha pahalı sayar.
func kalabalik_yolu(bas: Vector2i, adaylar: Array[Vector2i], dolu: Dictionary, trafik: Dictionary) -> Array[Vector2i]:
	var kapatilanlar := PackedInt64Array()
	var agirliklar := {}
	for h in dolu:
		if h != bas and gecilir(h):
			var id := _id(h)
			if not _ag.is_point_disabled(id):
				_ag.set_point_disabled(id)
				kapatilanlar.append(id)
	for h in trafik:
		if h != bas and not dolu.has(h) and gecilir(h):
			var id := _id(h)
			var agirlik := _ag.get_point_weight_scale(id)
			agirliklar[id] = agirlik
			_ag.set_point_weight_scale(id, agirlik + 2.0 * _zemin_maliyeti * int(trafik[h]))
	var sonuc: Array[Vector2i] = []
	for aday in adaylar:
		sonuc = yol(bas, aday)
		if not sonuc.is_empty():
			break
	for id in agirliklar:
		_ag.set_point_weight_scale(id, float(agirliklar[id]))
	for id in kapatilanlar:
		_ag.set_point_disabled(id, false)
	if sonuc.is_empty():
		for aday in adaylar:
			sonuc = yol(bas, aday)
			if not sonuc.is_empty():
				break
	return sonuc

## Kapalı hücrede kalan karakteri en yakın açık hücreye taşımak için güvenli başlangıç.
func yakin(h: Vector2i) -> Vector2i:
	var id := _ag.get_closest_point(Vector3(h.x, 0, h.y))
	return _hucre(id) if id >= 0 else Vector2i(-1, -1)

## Binanın erişilebilir çevresinde bir durak seçer; yapı merkezine girmez.
func bina_duragi(bas: Vector2i, alan: Rect2i, sira: int) -> Vector2i:
	var adaylar: Array[Vector2i] = []
	for y in range(alan.position.y - 1, alan.end.y + 1):
		for x in range(alan.position.x - 1, alan.end.x + 1):
			var h := Vector2i(x, y)
			if alan.has_point(h) or not gecilir(h):
				continue
			if not yol(bas, h).is_empty():
				adaylar.append(h)
	# Yol üzerindeki duraklar önce gelir; eşitlikte kararlı hücre sırası korunur.
	adaylar.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
		return int(_izgara.yollar.has(a)) > int(_izgara.yollar.has(b)))
	return adaylar[posmod(sira, adaylar.size())] if not adaylar.is_empty() else Vector2i(-1, -1)

func _id(h: Vector2i) -> int:
	return h.y * _izgara.boyut.x + h.x

func _hucre(id: int) -> Vector2i:
	return Vector2i(id % _izgara.boyut.x, id / _izgara.boyut.x)
