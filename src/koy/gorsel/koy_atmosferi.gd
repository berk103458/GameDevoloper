## Köyün ışığı ve havası (görsel tasarım md, madde 5): gündüz sarımtırak sınır güneşi, akşam kızıllığı, gece ay
## ışığı ve meydan ateşi. `faz` geçişi yumuşaktır (tween); gökyüzü en karanlık anında değiştirilir, sıçrama görünmez.
## 4 GB VRAM: gölgeli ışık yalnız güneş ve meydan ateşi; kandil ve meşaleler gölgesizdir (KoyYonetimSahnesi).
class_name KoyAtmosferi
extends Node3D

const ORTAM_ENERJISI: Dictionary = preload("res://data/ayarlar/sahne.json").data.koy_isik.ortam_enerjisi

## Faz → görünüm. Gök: Poly Haven HDRI kimliği (assets/ph/gok).
const FAZLAR := {
	&"gunduz": {"gok": "kloofendal_48d_partly_cloudy_puresky", "gok_enerji": 0.9, "gunes": Color("#fff0da"),
		"gunes_enerji": 1.6, "aci": Vector3(-48, 30, 0), "sis": Color("#b4c0c8"), "ates": 1.2},
	&"aksam": {"gok": "kloppenheim_06_puresky", "gok_enerji": 0.55, "gunes": Color("#ffc58a"),
		"gunes_enerji": 1.1, "aci": Vector3(-18, -60, 0), "sis": Color("#a08670"), "ates": 2.4},
	&"gece": {"gok": "satara_night_no_lamps", "gok_enerji": 0.4, "gunes": Color("#7d93c4"),
		"gunes_enerji": 0.34, "aci": Vector3(-55, 120, 0), "sis": Color("#1c2433"), "ates": 3.4},
}

const SAAT := {&"safak": 5.4, &"gunduz": 9.5, &"aksam": 18.85, &"gece": 22.6}
const SIS := {&"safak": 0.0026, &"gunduz": 0.0009, &"aksam": 0.002, &"gece": 0.0034}
const AY := [4, 7, 10, 1]

var faz_adi: StringName = &"aksam"
var cevre: Environment
var gunes: DirectionalLight3D
## Meydan ateşinin taban gücü (sahne titreşimi bunun üstüne uygular).
var ates_gucu := 2.4
var _gok: PanoramaSkyMaterial
var _sky: Sky3D
var _tween: Tween


func _ready() -> void:
	_sky = Sky3D.new()
	_sky.name = &"Sky3D"
	add_child(_sky)
	if _sky.sun == null or _sky.environment == null or _sky.tod == null:
		_sky.queue_free()
		_sky = null
		_eski_kur()
		faz(faz_adi, 0.0)
		return
	# Samanyolu dokusu eklentinin kendi STARMAP'idir: ESO/S. Brunier, CC BY 4.0.
	cevre = _sky.environment
	cevre.tonemap_mode = Environment.TONE_MAPPER_AGX
	cevre.tonemap_exposure = 1.1
	cevre.fog_enabled = true
	cevre.fog_density = 0.0016
	cevre.fog_sky_affect = 0.35
	cevre.adjustment_enabled = true
	cevre.adjustment_contrast = 1.12
	cevre.adjustment_saturation = 1.2
	cevre.ssao_enabled = true
	cevre.glow_enabled = true
	cevre.glow_intensity = 0.35
	cevre.glow_hdr_threshold = 1.4
	gunes = _sky.sun
	gunes.shadow_enabled = true
	gunes.directional_shadow_max_distance = 140.0
	_sky.tod.game_time_enabled = false
	_sky.tod.year = 1352
	_takvim()
	faz(faz_adi, 0.0)


func _eski_kur() -> void:
	cevre = Environment.new()
	cevre.background_mode = Environment.BG_SKY
	var gok := Sky.new()
	_gok = PanoramaSkyMaterial.new()
	gok.sky_material = _gok
	cevre.sky = gok
	cevre.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	cevre.tonemap_mode = Environment.TONE_MAPPER_AGX
	cevre.tonemap_exposure = 1.1
	cevre.fog_enabled = true
	cevre.fog_density = 0.0016
	cevre.fog_sky_affect = 0.3
	cevre.adjustment_enabled = true
	cevre.adjustment_contrast = 1.12
	cevre.adjustment_saturation = 1.2
	cevre.ssao_enabled = true
	cevre.glow_enabled = true
	cevre.glow_intensity = 0.35
	cevre.glow_hdr_threshold = 1.4
	var we := WorldEnvironment.new()
	we.environment = cevre
	add_child(we)
	gunes = DirectionalLight3D.new()
	gunes.shadow_enabled = true
	gunes.directional_shadow_max_distance = 140.0
	add_child(gunes)


## Işığı `ad` fazına geçirir (`sure` saniyede; 0 = anında).
func faz(ad: StringName, sure: float = 2.0) -> void:
	var f: Dictionary = FAZLAR.get(ad, FAZLAR[&"aksam"])
	var ortam := float(ORTAM_ENERJISI.get(String(ad), ORTAM_ENERJISI.aksam))
	var once := faz_adi
	faz_adi = ad
	_takvim()
	if _sky != null:
		_sky_faz(ad, once, f, ortam, sure)
		return
	if _tween != null and _tween.is_valid():
		_tween.kill()
	if sure <= 0.0:
		_gok.panorama = Pbr.gok(f["gok"])
		_gok.energy_multiplier = f["gok_enerji"]
		gunes.light_color = f["gunes"]
		gunes.light_energy = f["gunes_enerji"]
		gunes.rotation_degrees = f["aci"]
		cevre.ambient_light_energy = ortam
		cevre.fog_light_color = f["sis"]
		ates_gucu = f["ates"]
		return
	_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(gunes, "light_color", f["gunes"], sure)
	_tween.tween_property(gunes, "light_energy", f["gunes_enerji"], sure)
	_tween.tween_property(gunes, "rotation_degrees", f["aci"], sure)
	_tween.tween_property(cevre, "ambient_light_energy", ortam, sure)
	_tween.tween_property(cevre, "fog_light_color", f["sis"], sure)
	_tween.tween_property(self, "ates_gucu", f["ates"], sure)
	# Gök: yarı yolda kararır, değişir, yeniden açılır.
	var gok_t := create_tween()
	gok_t.tween_property(_gok, "energy_multiplier", 0.04, sure * 0.5)
	gok_t.tween_callback(func() -> void: _gok.panorama = Pbr.gok(f["gok"]))
	gok_t.tween_property(_gok, "energy_multiplier", f["gok_enerji"], sure * 0.5)


func _sky_faz(ad: StringName, once: StringName, f: Dictionary, ortam: float, sure: float) -> void:
	var hedef := float(SAAT.get(ad, SAAT[&"aksam"]))
	var bas := hedef
	if once == &"gece" and ad == &"gunduz" and sure > 0.0:
		bas = float(SAAT[&"safak"])
	var sis := float(SIS.get(ad, 0.0016))
	if _tween != null and _tween.is_valid():
		_tween.kill()
	gunes.light_color = f["gunes"]
	cevre.fog_light_color = f["sis"]
	ates_gucu = f["ates"]
	if _sky.moon != null:
		_sky.moon.light_energy = 0.22 if ad == &"gece" else 0.04
	if _sky.sky != null:
		_sky.sky.fog_visible = true
		_sky.sky.fog_density = sis
	if sure <= 0.0:
		_sky.tod.current_time = hedef
		gunes.light_energy = f["gunes_enerji"]
		cevre.ambient_light_energy = ortam
		cevre.fog_density = sis
		return
	_sky.tod.current_time = bas
	_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(_sky.tod, "current_time", hedef, sure)
	_tween.tween_property(gunes, "light_energy", f["gunes_enerji"], sure)
	_tween.tween_property(cevre, "ambient_light_energy", ortam, sure)
	_tween.tween_property(cevre, "fog_density", sis, sure)


func _takvim() -> void:
	if _sky == null or _sky.tod == null:
		return
	var s := get_parent() as KoyYonetimSahnesi
	if s == null or s.yonetim == null:
		return
	var indeks := Takvim.mevsim(s.yonetim.gun, s.yonetim.a.mevsim_gun)
	_sky.tod.month = AY[indeks]
	_sky.tod.day = mini(28, Takvim.mevsim_gunu(s.yonetim.gun, s.yonetim.a.mevsim_gun))
