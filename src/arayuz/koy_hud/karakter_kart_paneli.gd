## Tıklanan köylünün kartı: canlı 3B portre (aynı model, ayrı küçük dünyada döner), adı, sınıfı, kökeni,
## işi, şu anki hâli ve kapıdaki kaydı (kabul / rüşvet / kışla, kaçıncı gece). "Konuş" köylünün ağzından
## bir söz çıkarır: Halk barı düşükse söz de karamsardır.
class_name KarakterKartPaneli
extends PanelContainer

signal kapandi

var oturum: Oturum
var ai: KoyluAI

var _portre_vp: SubViewport
var _model: Node3D
var _soz: Label
var _simdi: Label
var _soz_sira := 0


func _ready() -> void:
	custom_minimum_size = Vector2(500, 0)
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 16)
	add_child(kenar)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	kenar.add_child(v)
	var ust := HBoxContainer.new()
	ust.add_theme_constant_override("separation", 16)
	v.add_child(ust)
	ust.add_child(_portre_kur())
	var bilgi := VBoxContainer.new()
	bilgi.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bilgi.add_theme_constant_override("separation", 6)
	ust.add_child(bilgi)
	var k: Dictionary = ai.kisi
	var ad := tr("arayuz.kart.adsiz")
	var koken := ""
	if k["adli_id"] != &"" and oturum.katalog.karakter(k["adli_id"]) != null:
		var kv := oturum.katalog.karakter(k["adli_id"])
		ad = tr(kv.ad_anahtari)
		koken = tr(kv.koken)
	elif String(k["ad_anahtari"]) != "":
		ad = tr(k["ad_anahtari"])
	var baslik := HudYardim.etiket(ad, &"Baslik", 30)
	baslik.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	bilgi.add_child(baslik)
	var sinif := tr("arayuz.sinif." + String(k["sinif"])).capitalize()
	bilgi.add_child(HudYardim.etiket(sinif + ("  ·  " + koken if koken != "" else ""), &"", 22))
	var is_l := HudYardim.etiket(tr("arayuz.kart.is") % tr(ai.is_anahtari()), &"", 22)
	bilgi.add_child(is_l)
	_simdi = HudYardim.etiket("", &"", 22)
	bilgi.add_child(_simdi)
	var kayit := HBoxContainer.new()
	kayit.add_theme_constant_override("separation", 8)
	var karar := String(k["karar"])
	kayit.add_child(HudYardim.simge({"rusvet": "swap-bag", "kisla": "checked-shield", "olay": "scales"}.get(karar, "hand"), 26.0))
	var gece: int = int(k["gece"])
	var kayit_yazi := tr("arayuz.kart.karar." + karar) + "  ·  " + (tr("arayuz.kart.giris") % gece if gece > 0 else tr("arayuz.kart.giris_bilinmez"))
	var kl := HudYardim.etiket(kayit_yazi, &"", 20)
	kl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	kl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kl.add_theme_color_override("font_color", Renkler.BRONZ_ACIK if karar == "rusvet" else Renkler.PARSOMEN)
	kayit.add_child(kl)
	bilgi.add_child(kayit)
	_soz = HudYardim.etiket("", &"", 22)
	_soz.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_soz.add_theme_color_override("font_color", Renkler.BRONZ_ACIK.lightened(0.25))
	_soz.visible = false
	v.add_child(_soz)
	var dugmeler := HBoxContainer.new()
	dugmeler.add_theme_constant_override("separation", 12)
	v.add_child(dugmeler)
	var konus := Button.new()
	konus.text = tr("arayuz.kart.konus")
	konus.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	konus.pressed.connect(_konus)
	dugmeler.add_child(konus)
	var kapat := Button.new()
	kapat.text = tr("arayuz.kart.kapat")
	kapat.pressed.connect(func() -> void: kapandi.emit())
	dugmeler.add_child(kapat)
	konus.grab_focus.call_deferred()


func _process(delta: float) -> void:
	if _model != null:
		_model.rotation.y += delta * 0.6 / maxf(Engine.time_scale, 0.25)
	if _simdi != null and is_instance_valid(ai):
		_simdi.text = tr("arayuz.kart.simdi") % tr(ai.durum_anahtari())


func _konus() -> void:
	Ses.cal(&"sfx_onay", -8.0)
	var sinif := String(ai.kisi["sinif"])
	var ruh := "kotu" if int(oturum.barlar.degerler[0]) <= 4 else "iyi"
	_soz_sira = (_soz_sira % 2) + 1
	var n := ((ai.sira + _soz_sira) % 2) + 1
	_soz.text = "“%s”" % tr("arayuz.konus.%s.%s%d" % [sinif, ruh, n])
	_soz.visible = true


## Ayrı dünyada küçük bir sahne: aynı model, sıcak ışık, yavaşça döner.
func _portre_kur() -> Control:
	var kap := SubViewportContainer.new()
	kap.custom_minimum_size = Vector2(170, 210)
	kap.stretch = true
	kap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_portre_vp = SubViewport.new()
	_portre_vp.own_world_3d = true
	_portre_vp.transparent_bg = true
	_portre_vp.msaa_3d = Viewport.MSAA_4X
	kap.add_child(_portre_vp)
	var kok := Node3D.new()
	_portre_vp.add_child(kok)
	var dunya := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Renkler.SOGUK_MAVI
	env.ambient_light_energy = 0.7
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	dunya.environment = env
	kok.add_child(dunya)
	var isik := OmniLight3D.new()
	isik.light_color = Renkler.MESALE
	isik.light_energy = 3.5
	isik.omni_range = 6.0
	isik.position = Vector3(-0.9, 1.9, 1.4)
	kok.add_child(isik)
	var k: Dictionary = ai.kisi
	var model := Dunya3B.karakter_adi(k["adli_id"], k["portre"], k["sinif"])
	_model = Dunya3B.karakter(model)
	kok.add_child(_model)
	var kam := Camera3D.new()
	kam.fov = 30.0
	kam.position = Vector3(0, 1.35, 2.6)
	kok.add_child(kam)
	kam.look_at(Vector3(0, 1.2, 0))
	return kap
