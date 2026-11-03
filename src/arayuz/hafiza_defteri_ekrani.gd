## HFZ-03, HFZ-04, HFZ-15, HFZ-16, HFZ-18, HFZ-19
## Tek defter ekrani. Kapidaki sorgu defteri bu sinif degildir.
## Hiz burada yazilmaz; punto tema ve ayarlar.boyut() uzerinden gelir.
class_name HafizaDefteriEkrani
extends Control

signal kapandi

var ayarlar: Ayarlar
var defter: HafizaDefteri
var kaynak: Dictionary = {}
var eski_hiz: int = 1
var sayfa: int = 0
var kapali: bool = false
var filtre: String = ""
var okunmus_isaret: bool = false
var ilk_sayfa_odakta: bool = false

var _sayfa_dugmeleri: Array[Button] = []
var _liste: VBoxContainer
var _bos: Label
var _filtre: LineEdit
var _kuruldu: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	kur()
	if is_inside_tree() and not _sayfa_dugmeleri.is_empty():
		_sayfa_dugmeleri[0].grab_focus()


func kur() -> void:
	if _kuruldu:
		return
	_kuruldu = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	if defter == null:
		defter = HafizaDefteri.new()
	defter.tavan_yukle()
	_kur()
	sayfa_sec(0)
	ilk_sayfa_odakta = true


func punto(taban: int) -> int:
	if ayarlar == null:
		return taban
	return ayarlar.boyut(taban)


func hiz_korunur(onceki: int) -> bool:
	return eski_hiz == onceki


func sayfa_sec(indeks: int) -> void:
	if HafizaDefteri.SAYFALAR.is_empty():
		return
	sayfa = posmod(indeks, HafizaDefteri.SAYFALAR.size())
	for i in _sayfa_dugmeleri.size():
		_sayfa_dugmeleri[i].set_pressed_no_signal(i == sayfa)
	_listeyi_ciz()


func girdi(eylem: StringName) -> void:
	match eylem:
		&"geri":
			kapat()
		&"kisayol_1":
			sayfa_sec(0)
		&"kisayol_2":
			sayfa_sec(1)
		&"kisayol_3":
			sayfa_sec(2)
		&"kisayol_4":
			sayfa_sec(3)
		&"ui_right", &"ui_focus_next":
			sayfa_sec(sayfa + 1)
		&"ui_left", &"ui_focus_prev":
			sayfa_sec(sayfa - 1)


func kapat() -> void:
	if kapali:
		return
	kapali = true
	kapandi.emit()
	queue_free()


func gorunen_satirlar() -> Array:
	if defter == null:
		return []
	var sayfa_adi := HafizaDefteri.SAYFALAR[sayfa]
	var hepsi: Dictionary = defter.oku(kaynak)
	return defter.suz(hepsi.get(sayfa_adi, []), filtre)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed() or event.is_echo():
		return
	var eylemler: Array[StringName] = [
		&"geri", &"kisayol_1", &"kisayol_2", &"kisayol_3", &"kisayol_4",
		&"ui_left", &"ui_right", &"ui_focus_prev", &"ui_focus_next",
	]
	for eylem in eylemler:
		if InputMap.has_action(eylem) and event.is_action_pressed(eylem):
			girdi(eylem)
			var gorunum := get_viewport()
			if gorunum != null:
				gorunum.set_input_as_handled()
			return


func _kur() -> void:
	var zemin := PanelContainer.new()
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	zemin.add_theme_stylebox_override("panel", Tema.koy_paneli())
	add_child(zemin)
	var kenar := MarginContainer.new()
	for yon in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(yon, 18)
	zemin.add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 8)
	kenar.add_child(dikey)
	var baslik := _yazi(tr("hafiza.ekran.baslik"), Tema.BASLIK_PX)
	dikey.add_child(baslik)
	var sekmeler := HBoxContainer.new()
	sekmeler.add_theme_constant_override("separation", 8)
	dikey.add_child(sekmeler)
	for sayfa_adi in HafizaDefteri.SAYFALAR:
		var dugme := Button.new()
		dugme.name = "sayfa_" + sayfa_adi
		dugme.text = _sayfa_adi(sayfa_adi)
		dugme.toggle_mode = true
		dugme.add_theme_font_size_override("font_size", punto(Tema.KUCUK_PX))
		var indeks := _sayfa_dugmeleri.size()
		dugme.pressed.connect(func() -> void: sayfa_sec(indeks))
		sekmeler.add_child(dugme)
		_sayfa_dugmeleri.append(dugme)
	_filtre = LineEdit.new()
	_filtre.name = "filtre"
	_filtre.placeholder_text = tr("hafiza.filtre.kisi")
	_filtre.add_theme_font_size_override("font_size", punto(Tema.GOVDE_PX))
	_filtre.text_changed.connect(func(metin: String) -> void:
		filtre = metin
		_listeyi_ciz()
	)
	dikey.add_child(_filtre)
	var kaydir := ScrollContainer.new()
	kaydir.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dikey.add_child(kaydir)
	_liste = VBoxContainer.new()
	_liste.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kaydir.add_child(_liste)
	_bos = _yazi("", Tema.GOVDE_PX)
	_bos.name = "bos_sayfa"
	dikey.add_child(_bos)


func _listeyi_ciz() -> void:
	if _liste == null or defter == null:
		return
	for cocuk in _liste.get_children():
		_liste.remove_child(cocuk)
		cocuk.queue_free()
	var sayfa_adi := HafizaDefteri.SAYFALAR[sayfa]
	var satirlar := gorunen_satirlar()
	_bos.visible = satirlar.is_empty()
	_bos.text = _bos_metni(sayfa_adi)
	for satir in satirlar:
		if not satir is Dictionary:
			continue
		_liste.add_child(_satir_kutusu(satir))
	for satir in satirlar:
		if satir is Dictionary:
			defter.satir_goruldu(String((satir as Dictionary).get("id", "")))


func _satir_kutusu(satir: Dictionary) -> Control:
	var kutu := VBoxContainer.new()
	var soluk := defter.soluk_mu(okunmus_isaret, String(satir.get("id", "")))
	kutu.modulate = Color(1, 1, 1, 0.45) if soluk else Color(1, 1, 1, 1)
	var baslik := _yazi(String(satir.get("baslik", "")), Tema.GOVDE_PX)
	kutu.add_child(baslik)
	var govde := String(satir.get("govde_anahtari", satir.get("metin_anahtari", "")))
	if not govde.is_empty():
		kutu.add_child(_yazi(govde, Tema.KUCUK_PX))
	var etiket := String(satir.get("etiket", ""))
	if not etiket.is_empty():
		kutu.add_child(_yazi(etiket, Tema.KUCUK_PX))
	var durum := String(satir.get("durum_anahtari", ""))
	if not durum.is_empty():
		kutu.add_child(_yazi(durum, Tema.KUCUK_PX))
	if bool(satir.get("celiski", false)):
		kutu.add_child(_yazi(tr("hafiza.etiket.celiski"), Tema.KUCUK_PX))
	return kutu


func _yazi(metin: String, taban: int) -> Label:
	var etiket := Label.new()
	etiket.text = metin
	etiket.add_theme_font_size_override("font_size", punto(taban))
	etiket.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return etiket


func _bos_metni(sayfa_adi: String) -> String:
	match sayfa_adi:
		"beyan":
			return tr("hafiza.bos.beyan")
		"soylenti":
			return tr("hafiza.bos.soylenti")
		"not":
			return tr("hafiza.bos.not")
		_:
			return tr("hafiza.bos.karar")


func _sayfa_adi(sayfa_adi: String) -> String:
	match sayfa_adi:
		"beyan":
			return tr("hafiza.sayfa.beyan")
		"soylenti":
			return tr("hafiza.sayfa.soylenti")
		"not":
			return tr("hafiza.sayfa.not")
		_:
			return tr("hafiza.sayfa.karar")
