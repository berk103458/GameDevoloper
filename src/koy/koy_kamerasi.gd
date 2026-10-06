## Köy RTS kamerası: WASD ile kayar, Q/E ile döner, tekerlekle yakınlaşır. Yakınlaştıkça eğim yatar
## (yakında −30°, uzakta −65°). Hareketler yumuşatılır. Fare tekerleği ve orta tuş sürükleme
## `KoyEkrani` tarafından iletilir (SubViewport içindeyiz).
class_name KoyKamerasi
extends Camera3D

const KAYMA_HIZI := 16.0
const DONME_HIZI := 1.6
const SINIR := 34.0

var ayar: KoyGorunumAyarlari
## Bakılan nokta (zeminde).
var odak := Vector3(0, 0, -2)
var yaw := 0.35
var uzaklik := 24.0
## Klavye denetimi açık mı (olay kartı açıkken kapatılır).
var klavye := true

var _hedef_odak := Vector3(0, 0, -2)
var _hedef_yaw := 0.35
var _hedef_uzaklik := 24.0


func _ready() -> void:
	fov = 50.0
	far = 260.0
	_uygula()


## Tekerlek: + yakınlaşır, − uzaklaşır.
func yakinlas(adim: float) -> void:
	_hedef_uzaklik = clampf(_hedef_uzaklik * (1.0 - adim * 0.12), ayar.kamera_yakin, ayar.kamera_uzak)


func dondur(radyan: float) -> void:
	_hedef_yaw += radyan


## Ekran düzleminde kaydırır (sağ, ileri) — metre.
func kaydir(sag: float, ileri: float) -> void:
	var ileri_v := Vector3(-sin(_hedef_yaw), 0, -cos(_hedef_yaw))
	var sag_v := Vector3(cos(_hedef_yaw), 0, -sin(_hedef_yaw))
	_hedef_odak += sag_v * sag + ileri_v * ileri
	var d := Vector2(_hedef_odak.x, _hedef_odak.z)
	if d.length() > SINIR:
		d = d.normalized() * SINIR
		_hedef_odak = Vector3(d.x, 0, d.y)


## Bir noktaya yumuşakça odaklanır (ör. seçilen köylü).
func odaklan(nokta: Vector3) -> void:
	_hedef_odak = Vector3(nokta.x, 0, nokta.z)


func _process(delta: float) -> void:
	# Duraklatmada (time_scale 0) da kamera oynasın: gerçek zaman kullanılır.
	var gercek := delta / maxf(Engine.time_scale, 0.0001) if Engine.time_scale > 0.0 else 1.0 / 60.0
	gercek = minf(gercek, 0.1)
	if klavye:
		var sag := 0.0
		var ileri := 0.0
		if Input.is_physical_key_pressed(KEY_W):
			ileri += 1.0
		if Input.is_physical_key_pressed(KEY_S):
			ileri -= 1.0
		if Input.is_physical_key_pressed(KEY_D):
			sag += 1.0
		if Input.is_physical_key_pressed(KEY_A):
			sag -= 1.0
		var hiz := KAYMA_HIZI * (0.5 + _hedef_uzaklik / ayar.kamera_uzak)
		if sag != 0.0 or ileri != 0.0:
			kaydir(sag * hiz * gercek, ileri * hiz * gercek)
		if Input.is_physical_key_pressed(KEY_Q):
			dondur(-DONME_HIZI * gercek)
		if Input.is_physical_key_pressed(KEY_E):
			dondur(DONME_HIZI * gercek)
	var k := clampf(gercek * 6.0, 0.0, 1.0)
	odak = odak.lerp(_hedef_odak, k)
	yaw = lerp_angle(yaw, _hedef_yaw, k)
	uzaklik = lerpf(uzaklik, _hedef_uzaklik, k)
	_uygula()


func _uygula() -> void:
	if ayar == null:
		return
	var t := inverse_lerp(ayar.kamera_yakin, ayar.kamera_uzak, uzaklik)
	var egim := deg_to_rad(lerpf(ayar.kamera_egim_yakin, ayar.kamera_egim_uzak, t))
	var geri := Vector3(sin(yaw), 0, cos(yaw)) * cos(egim) * uzaklik
	position = odak + geri + Vector3(0, -sin(egim) * uzaklik, 0)
	look_at(odak + Vector3(0, 0.6, 0), Vector3.UP)
