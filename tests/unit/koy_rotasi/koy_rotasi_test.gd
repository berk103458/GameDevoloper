## Bina/engel kaçınması, yol tercihi, kopuk alan ve yeniden kurulum testleri.
extends SceneTree

var hata := 0

func _initialize() -> void:
	var i := Izgara.new(Vector2i(9, 7), Rect2i(0, 0, 1, 1))
	i.yollar.clear()
	for x in 9:
		i.yollar[Vector2i(x, 1)] = true
	i.dolu[Vector2i(4, 3)] = 1
	i.engeller[Vector2i(5, 3)] = true
	var r := KoyRotasi.new()
	r.kur(i, 4.0)
	var p := r.yol(Vector2i(0, 3), Vector2i(8, 3))
	_kontrol(not p.is_empty(), "Engellerin çevresinden rota")
	_kontrol(p.has(Vector2i(4, 1)), "Ucuz yol tercih edilir")
	for n in p.size():
		_kontrol(r.gecilir(p[n]), "Rota açık hücrede")
		if n > 0:
			var d: Vector2i = p[n] - p[n - 1]
			_kontrol(absi(d.x) + absi(d.y) == 1, "Köşe kesmeden dört komşu")
	_kontrol(r.yol(Vector2i.ZERO, Vector2i(4, 3)).is_empty(), "Bina içine rota yok")
	var durak := r.bina_duragi(Vector2i.ZERO, Rect2i(4, 3, 1, 1), 0)
	_kontrol(r.gecilir(durak) and not r.yol(Vector2i.ZERO, durak).is_empty(), "Erişilebilir bina durağı")
	for y in 7:
		i.engeller[Vector2i(3, y)] = true
	r.kur(i, 4.0)
	_kontrol(r.yol(Vector2i.ZERO, Vector2i(8, 3)).is_empty(), "Kopuk alan için kısmi rota yok")
	_kontrol(r.bina_duragi(Vector2i.ZERO, Rect2i(6, 3, 1, 1), 0) == Vector2i(-1, -1), "Kopuk binaya sahte durak yok")
	i.engeller.clear()
	i.dolu.clear()
	r.kur(i, 4.0)
	_kontrol(not r.yol(Vector2i.ZERO, Vector2i(8, 3)).is_empty(), "Engel kaldırılınca rota güncellenir")
	print("KÖY ROTA TEST: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
