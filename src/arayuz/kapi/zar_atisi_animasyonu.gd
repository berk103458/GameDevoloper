## BG3 tarzı kodla zar atışı: fırlatma, sekişme, sallanma. Sonuç önceden bellidir.
class_name ZarAtisiAnimasyonu
extends Control

signal bitti

const YUZ_KOK := "res://assets/ui/kapi/zar_yuz/"
const GOLGE_YOL := "res://assets/ui/kapi/zar_yuz/zar_golge.png"
const G := 9.4
const ZAR_PX := 176.0

var _tur: StringName = &"d6"
var _sonuc: int = 1
var _p: Dictionary = {}
var _yuzler: Array[Texture2D] = []
var _gecen := 0.0
var _zar: TextureRect
var _golge: TextureRect
var _parlama: ColorRect
var _oynuyor := false


static func yuz_sayisi(tur: StringName) -> int:
	return 12 if tur == &"d12" else 6


static func yuz_yolu(tur: StringName, yuz: int) -> String:
	var ad := "zar_d12_yuz_" if tur == &"d12" else "zar_d6_yuz_"
	return "%s%s%d.png" % [YUZ_KOK, ad, yuz]


static func yuzleri_yukle(tur: StringName) -> Array[Texture2D]:
	var kareler: Array[Texture2D] = []
	var adet := yuz_sayisi(tur)
	for no in range(1, adet + 1):
		var yol := yuz_yolu(tur, no)
		if not ResourceLoader.exists(yol):
			return []
		var doku: Texture2D = load(yol)
		if doku == null:
			return []
		kareler.append(doku)
	return kareler


static func parametreler(tur: StringName, sonuc: int, tohum: int) -> Dictionary:
	var adet := yuz_sayisi(tur)
	var r := RandomNumberGenerator.new()
	r.seed = tohum
	var n_sek := 2 if r.randf() < 0.42 else 3
	var soldan := r.randf() < 0.5
	var x0 := (0.20 + r.randf() * 0.16) if soldan else (0.64 + r.randf() * 0.16)
	var vx := (0.26 + r.randf() * 0.24) * (1.0 if soldan else -1.0)
	var h0 := 0.07 + r.randf() * 0.07
	var vh0 := 1.52 + r.randf() * 0.50
	var spin0 := (420.0 + r.randf() * 520.0) * (1.0 if r.randf() < 0.5 else -1.0)
	var rest: Array[float] = [0.56, 0.33, 0.17]
	var sekme: Array = []
	var h := h0
	var vh := vh0
	var x := x0
	var t := 0.0
	var spin := spin0
	for i in n_sek:
		# 0.5*G*t^2 - vh*t - h = 0
		var disk := vh * vh + 2.0 * G * h
		var dt := (vh + sqrt(maxf(disk, 0.0))) / G
		t += dt
		x += vx * dt
		var vh_carpim := -(vh - G * dt)
		var etki := absf(vh_carpim)
		spin *= 0.64
		vx *= 0.88
		vh = etki * rest[mini(i, rest.size() - 1)]
		h = 0.0
		sekme.append({"t": t, "x": x, "etki": etki, "spin": spin, "vx": vx, "vh": vh})
	var t_otur := t
	var sure := t_otur + 0.58
	var yuz_dizisi: Array[int] = []
	var adim := maxi(8, int(sure / 0.045))
	for _i in adim:
		var y := r.randi_range(1, adet)
		if y == clampi(sonuc, 1, adet) and r.randf() < 0.72:
			y = (y % adet) + 1
		yuz_dizisi.append(y)
	return {
		"tur": tur,
		"adet": adet,
		"sonuc": clampi(sonuc, 1, adet),
		"x0": x0,
		"h0": h0,
		"vh0": vh0,
		"vx0": vx,
		"spin0": spin0,
		"n_sek": n_sek,
		"sekme": sekme,
		"t_otur": t_otur,
		"sure": sure,
		"rest_aci": r.randf_range(-8.0, 8.0),
		"yuz_dizisi": yuz_dizisi,
		"vx": vx,
	}


static func ornekle(p: Dictionary, t: float) -> Dictionary:
	var sure := float(p["sure"])
	var t_otur := float(p["t_otur"])
	var sonuc: int = p["sonuc"]
	var clamp_t := clampf(t, 0.0, sure)
	var x := float(p["x0"])
	var h := float(p["h0"])
	var vh := float(p["vh0"])
	var vx := float(p["vx0"])
	var spin := float(p["spin0"])
	var aci := 0.0
	var evre := &"ucus"
	var etki_son := 0.0
	var t_sek_son := -1.0
	var t0 := 0.0
	var sekme: Array = p["sekme"]
	if clamp_t >= t_otur:
		evre = &"otur"
		var son: Dictionary = sekme[sekme.size() - 1]
		x = float(son["x"])
		h = 0.0
		aci = float(p["rest_aci"])
		var tau := clamp_t - t_otur
		aci += 14.0 * exp(-4.2 * tau) * sin(22.0 * tau)
		t_sek_son = t_otur
		etki_son = float(son["etki"])
	else:
		for i in sekme.size():
			var s: Dictionary = sekme[i]
			var ts := float(s["t"])
			if clamp_t <= ts:
				var dt := clamp_t - t0
				x += vx * dt
				h = h + vh * dt - 0.5 * G * dt * dt
				aci = spin * clamp_t
				if h < 0.0:
					h = 0.0
				evre = &"ucus"
				break
			t0 = ts
			x = float(s["x"])
			h = 0.0
			vh = float(s["vh"])
			vx = float(s["vx"])
			spin = float(s["spin"])
			t_sek_son = ts
			etki_son = float(s["etki"])
	var yuz: int = sonuc
	if evre == &"ucus":
		var dizi: Array = p["yuz_dizisi"]
		if not dizi.is_empty():
			var ix := clampi(int(clamp_t / 0.048), 0, dizi.size() - 1)
			yuz = int(dizi[ix])
	var golge_s := lerpf(1.18, 0.52, clampf(h, 0.0, 1.0))
	var golge_a := lerpf(0.50, 0.12, clampf(h, 0.0, 1.0))
	var olcek := 0.92 + h * 0.30
	var squash := 1.0
	var sars_x := 0.0
	var sars_y := 0.0
	if t_sek_son >= 0.0 and clamp_t >= t_sek_son:
		var ds := clamp_t - t_sek_son
		if ds < 0.09:
			squash = lerpf(0.76, 1.0, ds / 0.09)
		if ds < 0.13:
			var amp := clampf(etki_son * 0.014, 0.0, 0.035) * (1.0 - ds / 0.13)
			sars_x = amp * sin(ds * 70.0)
			sars_y = amp * 0.55 * cos(ds * 62.0)
	var parilti := 0.0
	if evre == &"otur":
		var tau2 := clamp_t - t_otur
		if tau2 < 0.16:
			parilti = 1.0 - tau2 / 0.16
	return {
		"x": x,
		"h": maxf(h, 0.0),
		"aci": aci,
		"olcek": olcek,
		"squash": squash,
		"yuz": yuz,
		"golge_s": golge_s,
		"golge_a": golge_a,
		"sars_x": sars_x,
		"sars_y": sars_y,
		"parilti": parilti,
		"evre": evre,
		"bitti": t >= sure,
	}


static func olustur(tur: StringName = &"d6", sonuc: int = 1, tohum: int = -1) -> ZarAtisiAnimasyonu:
	var yuzler := yuzleri_yukle(tur)
	if yuzler.size() < yuz_sayisi(tur):
		return null
	if tohum < 0:
		tohum = int(Time.get_ticks_usec())
	var n := ZarAtisiAnimasyonu.new()
	n._tur = tur
	n._sonuc = clampi(sonuc, 1, yuz_sayisi(tur))
	n._yuzler = yuzler
	n._p = parametreler(tur, n._sonuc, tohum)
	return n


static func oynat(ebeveyn: Control, tur: StringName = &"d6", ayarlar: Ayarlar = null, sonuc: int = 0) -> void:
	if ebeveyn == null:
		return
	var n := olustur(tur, sonuc if sonuc > 0 else 1)
	if n == null:
		return
	var aninda := false
	if ayarlar != null:
		aninda = ayarlar.al(&"belirme_hizi") == &"aninda"
	ebeveyn.add_child(n)
	if aninda:
		n._aninda_goster()
		await ebeveyn.get_tree().create_timer(0.22).timeout
	else:
		n._baslat()
		await n.bitti
	if is_instance_valid(n):
		var tw := n.create_tween()
		tw.tween_property(n, "modulate:a", 0.0, 0.28)
		await tw.finished
	if is_instance_valid(n):
		n.queue_free()


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 80
	var perde := ColorRect.new()
	perde.color = Color(0.02, 0.02, 0.03, 0.62)
	perde.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	perde.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(perde)
	_golge = TextureRect.new()
	_golge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_golge.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_golge.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if ResourceLoader.exists(GOLGE_YOL):
		_golge.texture = load(GOLGE_YOL)
	_golge.size = Vector2(220, 90)
	_golge.pivot_offset = _golge.size / 2.0
	add_child(_golge)
	_zar = TextureRect.new()
	_zar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_zar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_zar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_zar.size = Vector2(ZAR_PX, ZAR_PX)
	_zar.pivot_offset = _zar.size / 2.0
	if not _yuzler.is_empty():
		_zar.texture = _yuzler[0]
	add_child(_zar)
	_parlama = ColorRect.new()
	_parlama.color = Color(1.0, 0.94, 0.78, 0.0)
	_parlama.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_parlama.size = _zar.size
	_parlama.pivot_offset = _zar.size / 2.0
	add_child(_parlama)
	_uygula(ornekle(_p, 0.0))


func _baslat() -> void:
	_gecen = 0.0
	_oynuyor = true
	set_process(true)


func _aninda_goster() -> void:
	_oynuyor = false
	set_process(false)
	var s := ornekle(_p, float(_p["sure"]))
	s["parilti"] = 0.55
	_uygula(s)


func _process(dt: float) -> void:
	if not _oynuyor:
		return
	_gecen += dt
	var s := ornekle(_p, _gecen)
	_uygula(s)
	if bool(s["bitti"]):
		_oynuyor = false
		set_process(false)
		bitti.emit()


func _uygula(s: Dictionary) -> void:
	var sz := size
	if sz.x < 8.0 or sz.y < 8.0:
		sz = Vector2(1280, 720)
	var taban_y := sz.y * 0.70
	var cx := sz.x * float(s["x"]) + sz.x * float(s["sars_x"])
	var cy := taban_y - float(s["h"]) * sz.y * 0.36 + sz.y * float(s["sars_y"])
	var olcek := float(s["olcek"])
	var squash := float(s["squash"])
	var yuz: int = s["yuz"]
	if yuz >= 1 and yuz <= _yuzler.size():
		_zar.texture = _yuzler[yuz - 1]
	_zar.scale = Vector2(olcek, olcek * squash)
	_zar.rotation_degrees = float(s["aci"])
	_zar.position = Vector2(cx, cy) - _zar.pivot_offset
	_parlama.position = _zar.position
	_parlama.scale = _zar.scale
	_parlama.rotation = _zar.rotation
	_parlama.color.a = float(s["parilti"]) * 0.55
	var golge_s := float(s["golge_s"])
	_golge.scale = Vector2(golge_s * olcek, golge_s * 0.55 * olcek)
	_golge.modulate.a = float(s["golge_a"])
	_golge.position = Vector2(cx, taban_y + 18.0 + sz.y * float(s["sars_y"])) - _golge.pivot_offset
