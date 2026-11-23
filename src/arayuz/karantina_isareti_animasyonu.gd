## C4: bez karantina işareti kapıya / direğe asılır, salınıp oturur. Bir salgında bir kez.
class_name KarantinaIsaretiAnimasyonu
extends KodluSahneAnimasyonu

const ISARET := "res://assets/ui/koy/karantina_isareti/asili.png"
const INIS_S := 0.95
const META := &"karantina_isareti_oynadi"

var _isaret: TextureRect


static func olustur() -> KarantinaIsaretiAnimasyonu:
	if KodluSahneAnimasyonu.doku(ISARET) == null:
		return null
	var n := KarantinaIsaretiAnimasyonu.new()
	n._sure = 1.85
	n._perde_alfa = 0.48
	return n


static func oynat(ebeveyn: Control) -> void:
	if ebeveyn == null:
		return
	# HUD ilk belirmede bekletmeden de çalışabilir.
	KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(), KodluSahneAnimasyonu.aninda_mi(ebeveyn))


static func isaret_ornek(t: float) -> Dictionary:
	var u := clampf(t / INIS_S, 0.0, 1.0)
	var y := lerpf(-0.36, 0.0, KodluSahneAnimasyonu.settle(u, 0.09))
	var sönüm := 0.0 if t < INIS_S * 0.55 else clampf((t - INIS_S * 0.55) / 1.1, 0.0, 1.0)
	var salinim := 9.5 * exp(-2.6 * sönüm) * sin((t - INIS_S * 0.35) * 9.0) if t >= INIS_S * 0.35 else 0.0
	return {"y": y, "aci": salinim, "olcek": lerpf(0.94, 1.0, KodluSahneAnimasyonu.ease_out(u))}


func _sahne_kur() -> void:
	_isaret = _katman(KodluSahneAnimasyonu.doku(ISARET))
	add_child(_isaret)


func _uygula(t: float) -> void:
	if _isaret == null:
		return
	var s := isaret_ornek(t)
	var sz := size if size.x >= 8.0 else Vector2(1024, 1024)
	_isaret.pivot_offset = Vector2(sz.x * 0.5, sz.y * 0.18)
	_isaret.position = Vector2(0.0, sz.y * float(s["y"]))
	_isaret.rotation_degrees = float(s["aci"])
	_isaret.scale = Vector2(float(s["olcek"]), float(s["olcek"]))
