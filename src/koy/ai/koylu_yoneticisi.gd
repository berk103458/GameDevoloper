## Köylülerin yöneticisi: kararları dilimler (karede `karede_dusunen` köylü), yumuşak ayrışmayı hesaplar,
## kameraya uzak köylülerin animasyonunu yarı hıza indirir. Yürüme her karede tüm köylüler için yapılır.
class_name KoyluYoneticisi
extends Node

var ayar: KoyGorunumAyarlari
var koyluler: Array[KoyluAI] = []
## Köy saati (KoySahnesi yazar).
var saat := 16.5
var kamera: Camera3D

var _imlec := 0


func ekle(ai: KoyluAI) -> void:
	koyluler.append(ai)
	add_child(ai)


func _process(delta: float) -> void:
	var n := koyluler.size()
	if n == 0:
		return
	var dilim := mini(ayar.karede_dusunen, n)
	for k in dilim:
		_imlec = (_imlec + 1) % n
		var ai := koyluler[_imlec]
		ai.karar_ver(saat)
		_ayris(ai)
		if kamera != null:
			ai.govde.uzak_ayarla(kamera.global_position.distance_to(ai.govde.position) > ayar.lod_uzaklik)
	for ai in koyluler:
		ai.ilerle(delta)


## Yakındaki köylülerden uzaklaşma itmesi (yalnız görünür olanlar arasında).
func _ayris(ai: KoyluAI) -> void:
	if not ai.govde.visible:
		return
	var itme := Vector3.ZERO
	var m := ayar.ayrisma_mesafesi
	for b in koyluler:
		if b == ai or not b.govde.visible:
			continue
		var f := ai.govde.position - b.govde.position
		f.y = 0.0
		var d := f.length()
		if d < m and d > 0.001:
			itme += f / d * (m - d) * 2.5
		elif d <= 0.001:
			itme += Vector3(sin(ai.sira), 0, cos(ai.sira)) * 0.5
	ai.itme = itme.limit_length(1.2)
