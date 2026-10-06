## Köyün ışığı ve havası saate bağlıdır: ikindi (sıcak, alçak güneş) → akşam kızıllığı → gece (ay, soğuk mavi).
## Güneş/ay tek DirectionalLight3D'dir; gökyüzü ProceduralSky, sis hacimsel (Forward+), ton eşleme filmik.
## Meşaleler gölgesizdir; gölgeyi yalnız gök ışığı ve merkez ateşi düşürür.
class_name AtmosferYoneticisi
extends Node3D

## [saat, güneş rengi, güneş gücü, yükseklik (°), gök üstü, ufuk, ortam rengi, ortam gücü, sis rengi, sis yoğunluğu]
const ANAHTARLAR := [
	[16.0, Color(1.0, 0.82, 0.62), 1.25, -32.0, Color(0.32, 0.42, 0.58), Color(0.78, 0.62, 0.48), Color(0.62, 0.58, 0.52), 0.55, Color(0.62, 0.55, 0.48), 0.006],
	[18.0, Color(1.0, 0.62, 0.38), 0.95, -14.0, Color(0.22, 0.26, 0.4), Color(0.85, 0.5, 0.32), Color(0.52, 0.44, 0.42), 0.48, Color(0.58, 0.42, 0.34), 0.008],
	[19.3, Color(0.78, 0.45, 0.4), 0.42, -4.0, Color(0.1, 0.12, 0.22), Color(0.45, 0.28, 0.27), Color(0.36, 0.36, 0.46), 0.42, Color(0.24, 0.21, 0.27), 0.006],
	[20.5, Color(0.55, 0.66, 0.85), 0.32, -42.0, Color(0.025, 0.035, 0.06), Color(0.07, 0.09, 0.14), Color(0.29, 0.42, 0.54), 0.32, Color(0.08, 0.1, 0.15), 0.012],
]

var gunes: DirectionalLight3D
var env: Environment
var _gok: ProceduralSkyMaterial


func _ready() -> void:
	var dunya := WorldEnvironment.new()
	env = Environment.new()
	var sky := Sky.new()
	_gok = ProceduralSkyMaterial.new()
	_gok.sun_angle_max = 20.0
	sky.sky_material = _gok
	env.sky = sky
	env.background_mode = Environment.BG_SKY
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.tonemap_exposure = 1.05
	env.fog_enabled = true
	env.fog_sky_affect = 0.35
	# Hacimsel sis ve SSAO yalnız Forward+'ta var; Uyumluluk (OpenGL) çiziminde kapalı kalır.
	var ileri := RenderingServer.get_current_rendering_method() == "forward_plus"
	env.volumetric_fog_enabled = ileri
	env.volumetric_fog_density = 0.012
	env.volumetric_fog_length = 48.0
	env.volumetric_fog_ambient_inject = 0.3
	env.ssao_enabled = ileri
	env.ssao_intensity = 1.4
	dunya.environment = env
	add_child(dunya)
	gunes = DirectionalLight3D.new()
	gunes.shadow_enabled = true
	gunes.directional_shadow_max_distance = 70.0
	gunes.light_volumetric_fog_energy = 0.6
	add_child(gunes)


## Saati (24 saatlik, ondalıklı) ışığa ve havaya uygular.
func saat_uygula(saat: float) -> void:
	var a: Array = ANAHTARLAR[0]
	var b: Array = ANAHTARLAR[ANAHTARLAR.size() - 1]
	var t := 1.0
	if saat <= float(a[0]):
		b = a
	else:
		for i in range(ANAHTARLAR.size() - 1):
			if saat >= float(ANAHTARLAR[i][0]) and saat <= float(ANAHTARLAR[i + 1][0]):
				a = ANAHTARLAR[i]
				b = ANAHTARLAR[i + 1]
				t = inverse_lerp(float(a[0]), float(b[0]), saat)
				break
		if saat > float(b[0]):
			a = b
	t = smoothstep(0.0, 1.0, t)
	gunes.light_color = (a[1] as Color).lerp(b[1], t)
	gunes.light_energy = lerpf(a[2], b[2], t)
	# Güneş batıdan (−X) alçalır; ay doğudan yükselir. Gece anahtarına geçerken yön de döner.
	var gece := float(b[0]) >= 20.5
	var yon := lerpf(-115.0, 60.0, t) if gece else -115.0
	gunes.rotation_degrees = Vector3(lerpf(a[3], b[3], t), yon, 0)
	_gok.sky_top_color = (a[4] as Color).lerp(b[4], t)
	_gok.sky_horizon_color = (a[5] as Color).lerp(b[5], t)
	_gok.ground_horizon_color = _gok.sky_horizon_color.darkened(0.3)
	_gok.ground_bottom_color = _gok.sky_top_color.darkened(0.6)
	env.ambient_light_color = (a[6] as Color).lerp(b[6], t)
	env.ambient_light_energy = lerpf(a[7], b[7], t)
	env.fog_light_color = (a[8] as Color).lerp(b[8], t)
	env.fog_density = lerpf(a[9], b[9], t)
	env.volumetric_fog_albedo = env.fog_light_color
