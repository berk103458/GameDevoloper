## Köy yol bulma: 1 m'lik ızgarada A* (AStarGrid2D). Yapılar yürünemez; yollar ucuz, çayır pahalıdır,
## böylece köylüler kendiliğinden yolu izler. Düz arazide AStar3D'nin üçüncü boyutu gereksiz olduğu için
## ızgara sürümü kullanılır (aynı sonuç, daha az bellek).
class_name KoyNavigasyon
extends RefCounted

const YARICAP := 40  # ızgara -40..+40 m
const YOL_AGIRLIK := 0.55
const CAYIR_AGIRLIK := 1.4

var _izgara := AStarGrid2D.new()


## Yerleşim planından ızgarayı kurar.
func _init(y: KoyYerlesimi) -> void:
	_izgara.region = Rect2i(-YARICAP, -YARICAP, YARICAP * 2, YARICAP * 2)
	_izgara.cell_size = Vector2.ONE
	_izgara.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	_izgara.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	_izgara.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	_izgara.update()
	for z in range(-YARICAP, YARICAP):
		for x in range(-YARICAP, YARICAP):
			_izgara.set_point_weight_scale(Vector2i(x, z), CAYIR_AGIRLIK)
	for yol in y.yollar:
		_yol_isle(yol[0], yol[1], float(yol[2]) * 0.5 + 0.5)
	for e in y.engeller:
		_engel_isle(e[0], e[1])


## İki dünya noktası arasında yürüme noktaları (ilk nokta hariç). Yol yoksa doğrudan hedef.
func yol(a: Vector3, b: Vector3) -> PackedVector3Array:
	var ah := _bos_hucre(_hucre(a))
	var bh := _bos_hucre(_hucre(b))
	var sonuc := PackedVector3Array()
	if ah == bh or not _izgara.is_in_boundsv(ah) or not _izgara.is_in_boundsv(bh):
		sonuc.append(b)
		return sonuc
	var hucreler := _izgara.get_id_path(ah, bh, true)
	# Doğrusal ardışık noktaları atla (yalnız yön değişimleri kalır).
	var onceki_yon := Vector2i.ZERO
	for i in range(1, hucreler.size()):
		var yon := hucreler[i] - hucreler[i - 1]
		if yon != onceki_yon and i > 1:
			sonuc.append(_dunya(hucreler[i - 1]))
		onceki_yon = yon
	sonuc.append(b)
	return sonuc


func _hucre(p: Vector3) -> Vector2i:
	return Vector2i(clampi(floori(p.x), -YARICAP, YARICAP - 1), clampi(floori(p.z), -YARICAP, YARICAP - 1))


func _dunya(h: Vector2i) -> Vector3:
	return Vector3(h.x + 0.5, 0, h.y + 0.5)


## Hücre doluysa en yakın boş hücre (kapı önleri engel kenarında kalabilir).
func _bos_hucre(h: Vector2i) -> Vector2i:
	if not _izgara.is_point_solid(h):
		return h
	for r in range(1, 6):
		for dz in range(-r, r + 1):
			for dx in range(-r, r + 1):
				var c := h + Vector2i(dx, dz)
				if _izgara.is_in_boundsv(c) and not _izgara.is_point_solid(c):
					return c
	return h


func _engel_isle(m: Vector3, r: float) -> void:
	for z in range(floori(m.z - r), ceili(m.z + r) + 1):
		for x in range(floori(m.x - r), ceili(m.x + r) + 1):
			var h := Vector2i(x, z)
			if _izgara.is_in_boundsv(h) and Vector2(x + 0.5, z + 0.5).distance_to(Vector2(m.x, m.z)) <= r:
				_izgara.set_point_solid(h, true)


func _yol_isle(a3: Vector3, b3: Vector3, r: float) -> void:
	var a := Vector2(a3.x, a3.z)
	var b := Vector2(b3.x, b3.z)
	for z in range(floori(minf(a.y, b.y) - r), ceili(maxf(a.y, b.y) + r) + 1):
		for x in range(floori(minf(a.x, b.x) - r), ceili(maxf(a.x, b.x) + r) + 1):
			var h := Vector2i(x, z)
			var p := Vector2(x + 0.5, z + 0.5)
			if _izgara.is_in_boundsv(h) and p.distance_to(Geometry2D.get_closest_point_to_segment(p, a, b)) <= r:
				_izgara.set_point_weight_scale(h, YOL_AGIRLIK)
