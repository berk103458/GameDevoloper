## BUG-15: Heybe paneli açıkken sol tık dünya alanına ve 3B görüntü kapısına sızmamalı.
## Panel yeniden yazılmaz. Kapı ekranı heybe'yi `_dunya` dikdörtgeninin (0, 92, 1140×988) üstüne koyar;
## 3B doku `MOUSE_FILTER_IGNORE` bir TextureRect'tir ve SubViewport'a kendiliğinden tık iletmez.
## Bu betik iki yüzeyi de dener:
##  1) Kapıdaki dünya kontrolü (aynı dikdörtgen).
##  2) Godot'nun 3B'ye tık ilettiği SubViewportContainer (köy ekranındaki yol).
##   godot --headless --path . -s tests/unit/heybe/heybe_tik_test.gd
extends SceneTree

const DUNYA := Rect2(0, 92, 1140, 988)
const TIK := Vector2(400, 400)

var _hata := 0


class Sonda3B extends Node:
	var sol_tik := 0

	func _input(olay: InputEvent) -> void:
		if olay is InputEventMouseButton and olay.pressed and olay.button_index == MOUSE_BUTTON_LEFT:
			sol_tik += 1


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	root.size = Vector2i(1920, 1080)
	var kok := Control.new()
	kok.name = "Kok"
	kok.mouse_filter = Control.MOUSE_FILTER_IGNORE
	kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kok.size = Vector2(1920, 1080)
	kok.theme = Tema.olustur(Ayarlar.new("user://bug15_ayar.cfg"))
	root.add_child(kok)

	var dunya := Control.new()
	dunya.name = "DunyaAlani"
	dunya.position = DUNYA.position
	dunya.size = DUNYA.size
	dunya.mouse_filter = Control.MOUSE_FILTER_STOP
	var dunya_tik := [0]
	dunya.gui_input.connect(func(olay: InputEvent) -> void:
		if olay is InputEventMouseButton and olay.pressed and olay.button_index == MOUSE_BUTTON_LEFT:
			dunya_tik[0] += 1
	)
	kok.add_child(dunya)

	var doku := TextureRect.new()
	doku.name = "KapiDokusu"
	doku.mouse_filter = Control.MOUSE_FILTER_IGNORE
	doku.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kok.add_child(doku)
	kok.move_child(doku, 0)

	var panel := _panel()
	panel.position = DUNYA.position
	kok.add_child(panel)
	await process_frame
	await process_frame

	var zemin := panel.get_child(0)
	_esit("HeybePaneli mouse_filter STOP", panel.mouse_filter, Control.MOUSE_FILTER_STOP)
	_esit("zemin ColorRect", zemin is ColorRect, true)
	_esit("zemin mouse_filter STOP", zemin.mouse_filter, Control.MOUSE_FILTER_STOP)
	_esit("panel dünya dikdörtgenini kaplar", panel.get_global_rect().encloses(Rect2(TIK, Vector2.ONE)), true)
	print("  düğüm HeybePaneli.mouse_filter=%s zemin=%s:%s" % [
		_filtre(panel.mouse_filter), zemin.get_class(), _filtre(zemin.mouse_filter)])

	await _tik(TIK)
	var ust := root.gui_get_hovered_control()
	_esit("açıkken imleç heybe içinde", ust != null and (ust == panel or panel.is_ancestor_of(ust)), true)
	_esit("açıkken dünya kontrolü tık almaz", dunya_tik[0], 0)
	print("  açıkken hover=%s dünya_tık=%d" % [_yol(ust), dunya_tik[0]])

	await _panel_bitti(panel)
	panel.free()
	await process_frame
	await _tik(TIK)
	ust = root.gui_get_hovered_control()
	_esit("kapalıyken imleç dünya alanında", ust == dunya, true)
	_esit("kapalıyken dünya kontrolü tık alır", dunya_tik[0], 1)
	print("  kapalıyken hover=%s dünya_tık=%d" % [_yol(ust), dunya_tik[0]])

	dunya.free()
	var kap := SubViewportContainer.new()
	kap.name = "Kapi3B"
	kap.position = DUNYA.position
	kap.size = DUNYA.size
	kap.stretch = true
	kap.mouse_filter = Control.MOUSE_FILTER_STOP
	var vp := SubViewport.new()
	vp.size = Vector2i(int(DUNYA.size.x), int(DUNYA.size.y))
	vp.handle_input_locally = true
	kap.add_child(vp)
	var sonda := Sonda3B.new()
	sonda.name = "KapiSahnesiSonda"
	vp.add_child(sonda)
	kok.add_child(kap)
	var panel2 := _panel()
	panel2.position = DUNYA.position
	kok.add_child(panel2)
	await process_frame
	await process_frame
	await _tik(TIK)
	_esit("açıkken 3B SubViewport tık almaz", sonda.sol_tik, 0)
	ust = root.gui_get_hovered_control()
	_esit("açıkken 3B üstünde de imleç heybede", ust != null and (ust == panel2 or panel2.is_ancestor_of(ust)), true)
	print("  3B açık hover=%s sonda=%d" % [_yol(ust), sonda.sol_tik])

	await _panel_bitti(panel2)
	panel2.free()
	await process_frame
	await _tik(TIK)
	_esit("kapalıyken 3B SubViewport tık alır", sonda.sol_tik, 1)
	print("  3B kapalı sonda=%d" % sonda.sol_tik)

	print("HEYBE TIK: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _panel() -> HeybePaneli:
	var heybe := Heybe.new()
	heybe.ekle("arpa", "gida", 4, 1, false)
	heybe.soruldu = true
	var panel := HeybePaneli.new()
	panel.heybe = heybe
	panel.ayarlar = Ayarlar.new("user://bug15_ayar.cfg")
	panel.gelen_adi = "Yolcu"
	panel.beyan_metni = "kesemde arpa var"
	return panel


func _panel_bitti(panel: HeybePaneli) -> void:
	for _i in 50:
		if not is_instance_valid(panel) or not panel._mesgul:
			return
		await create_timer(0.1).timeout


func _tik(nokta: Vector2) -> void:
	var hareket := InputEventMouseMotion.new()
	hareket.position = nokta
	hareket.global_position = nokta
	root.push_input(hareket)
	await process_frame
	var bas := InputEventMouseButton.new()
	bas.button_index = MOUSE_BUTTON_LEFT
	bas.pressed = true
	bas.button_mask = MOUSE_BUTTON_MASK_LEFT
	bas.position = nokta
	bas.global_position = nokta
	root.push_input(bas)
	await process_frame


func _filtre(deger: MouseFilter) -> String:
	if deger == Control.MOUSE_FILTER_STOP:
		return "STOP"
	if deger == Control.MOUSE_FILTER_PASS:
		return "PASS"
	return "IGNORE"


func _yol(dugum: Node) -> String:
	if dugum == null:
		return "(yok)"
	return str(dugum.get_path())


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
