## AYR-01, AYR-04, AYR-50: Altı sekme. Kontroller ve Dil yalnız yuvadır.
## Değer anında uygulanır; dosya kapanınca yazılır.
class_name AyarSekmeleri
extends Control

const SEKMELER := [
	[&"oyun", "arayuz.ayarlar.sekme.oyun", "res://src/arayuz/ayarlar/oyun_sekmesi.gd"],
	[&"goruntu", "arayuz.ayarlar.sekme.goruntu", "res://src/arayuz/ayarlar/goruntu_sekmesi.gd"],
	[&"okuma", "arayuz.ayarlar.sekme.okuma", "res://src/arayuz/ayarlar/okuma_sekmesi.gd"],
	[&"ses", "arayuz.ayarlar.sekme.ses", "res://src/arayuz/ayarlar/ses_sekmesi.gd"],
	[&"kontroller", "arayuz.ayarlar.sekme.kontroller", "res://src/arayuz/ayarlar/kontroller_yuvasi.gd"],
	[&"dil", "arayuz.ayarlar.sekme.dil", "res://src/arayuz/ayarlar/dil_yuvasi.gd"],
]

var ayarlar: Ayarlar
var ekran: Control
var _icerik: Control
var _aciklama: Label
var _onay_sekmesi := &""


static func kur(hedef: Control) -> AyarSekmeleri:
	var s := AyarSekmeleri.new()
	s.ayarlar = hedef.get("ayarlar")
	s.ekran = hedef
	hedef.add_child(s)
	return s


static func sekme_sayisi() -> int:
	return SEKMELER.size()


static func betikler() -> PackedStringArray:
	var yollar := PackedStringArray()
	for satir in SEKMELER:
		yollar.append(String(satir[2]))
	return yollar


static func bos_yuvalar() -> PackedStringArray:
	return PackedStringArray([&"kontroller", &"dil"])


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for cocuk in ekran.get_children():
		if cocuk == self:
			continue
		if cocuk is MarginContainer or cocuk.get_script() != null and cocuk.get_script().resource_path.ends_with("grafik_ayarlari_paneli.gd"):
			cocuk.visible = false
	var kenar := MarginContainer.new()
	kenar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kenar.add_theme_constant_override("margin_left", 48)
	kenar.add_theme_constant_override("margin_top", 36)
	kenar.add_theme_constant_override("margin_right", 48)
	kenar.add_theme_constant_override("margin_bottom", 36)
	add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 12)
	kenar.add_child(dikey)
	var baslik := Label.new()
	baslik.text = tr("arayuz.ayarlar.baslik")
	dikey.add_child(baslik)
	var sekmeler := HBoxContainer.new()
	sekmeler.add_theme_constant_override("separation", 8)
	dikey.add_child(sekmeler)
	_icerik = VBoxContainer.new()
	_icerik.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dikey.add_child(_icerik)
	_aciklama = Label.new()
	_aciklama.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dikey.add_child(_aciklama)
	var alt := HBoxContainer.new()
	alt.add_theme_constant_override("separation", 12)
	dikey.add_child(alt)
	var sifir := Button.new()
	sifir.text = tr("arayuz.ayarlar.sekme_sifirla")
	sifir.pressed.connect(_sifirla)
	alt.add_child(sifir)
	var kapat := Button.new()
	kapat.text = tr("arayuz.ayarlar.geri")
	kapat.pressed.connect(_kapat)
	alt.add_child(kapat)
	for i in SEKMELER.size():
		var dugme := Button.new()
		dugme.text = tr(String(SEKMELER[i][1]))
		dugme.pressed.connect(_ac.bind(i))
		sekmeler.add_child(dugme)
	_ac(0)


func _ac(indeks: int) -> void:
	_onay_sekmesi = &""
	for c in _icerik.get_children():
		c.queue_free()
	var betik: GDScript = load(String(SEKMELER[indeks][2]))
	var sayfa: Control = betik.new()
	sayfa.set("ayarlar", ayarlar)
	sayfa.set("aciklama", _aciklama)
	if ekran != null and ekran.has_meta(&"ipucu_kaydi"):
		sayfa.set("ipucu_kaydi", ekran.get_meta(&"ipucu_kaydi"))
	_icerik.add_child(sayfa)
	_icerik.set_meta(&"sekme", SEKMELER[indeks][0])


func _sifirla() -> void:
	var sekme: StringName = _icerik.get_meta(&"sekme", &"")
	if _onay_sekmesi != sekme:
		_onay_sekmesi = sekme
		_aciklama.text = tr("arayuz.ayarlar.sekme_sifirla_onay")
		return
	AyarlarEk.sekme_sifirla(ayarlar, sekme, true)
	_onay_sekmesi = &""
	var indeks := 0
	for i in SEKMELER.size():
		if SEKMELER[i][0] == sekme:
			indeks = i
	_ac(indeks)


func _kapat() -> void:
	if ekran != null and ekran.has_method("_kapat"):
		ekran.call("_kapat")
