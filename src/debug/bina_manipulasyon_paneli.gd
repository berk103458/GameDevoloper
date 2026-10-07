class_name BinaManipulasyonPaneli
extends HBoxContainer

signal sonuc_alindi(sonuc: Dictionary)
var baglam: Node
var bitir: Button
var durum: Label
var secim: OptionButton
var seviye: Button
var sur_dugmeleri: Array[Button] = []
var _imza := ""

func _ready() -> void:
	bitir = Button.new()
	bitir.text = "Tüm inşaatları tamamla"
	bitir.pressed.connect(_bitir)
	add_child(bitir)
	secim = OptionButton.new()
	secim.custom_minimum_size.x = 180
	add_child(secim)
	seviye = Button.new()
	seviye.text = "+1 seviye"
	seviye.pressed.connect(func() -> void: _uygula("seviye"))
	add_child(seviye)
	for e in ["saglam", "hasarli", "yanmis"]:
		var b := Button.new()
		b.text = {"saglam": "Sur sağlam", "hasarli": "Sur hasarlı", "yanmis": "Sur yanmış"}[e]
		b.pressed.connect(_uygula.bind(e))
		add_child(b)
		sur_dugmeleri.append(b)
	durum = Label.new()
	durum.add_theme_font_size_override("font_size", 18)
	add_child(durum)
	yenile()

func yenile() -> void:
	bitir.disabled = not ZamanMakinesi.uygun(baglam)
	seviye.disabled = bitir.disabled
	var o: Oturum = baglam.get("oturum") if is_instance_valid(baglam) else null
	var adet := 0
	if o != null:
		for b in o.yonetim.binalar:
			if b.insa_kalan > 0:
				adet += 1
	var imza := "yok" if o == null else "%d:%s" % [o.get_instance_id(), JSON.stringify(o.yonetim.binalar.map(func(b: KoyBinasi) -> Array: return [b.id, b.seviye, b.insa_kalan]))]
	if imza != _imza:
		_imza = imza
		var id := secim.get_selected_id() if secim.item_count > 0 else 0
		secim.clear()
		secim.add_item("Sur", 0) # Bina kimlikleri 1'den başlar.
		if o != null:
			for b in o.yonetim.binalar:
				secim.add_item("#%d %s · S%d" % [b.id, b.tur, b.seviye], b.id)
		for i in secim.item_count:
			if secim.get_item_id(i) == id:
				secim.select(i)
	for b in sur_dugmeleri:
		b.disabled = bitir.disabled or o == null or o.yonetim.sur_seviye <= 0
	durum.text = "%d inşaat bekliyor" % adet

func _bitir() -> void:
	var sonuc := BinaManipulatoru.uygula(baglam)
	yenile()
	sonuc_alindi.emit(sonuc)

func _uygula(eylem: String) -> void:
	var id := secim.get_selected_id()
	var sonuc := BinaManipulatoru.uygula(baglam, eylem, -1 if id == 0 else id)
	yenile()
	sonuc_alindi.emit(sonuc)
