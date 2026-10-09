class_name KrizPaneli
extends PanelContainer
signal sonuc_alindi(sonuc: Dictionary)
var baglam: Node
var dugmeler: Array[Button] = []
var durum: Label
var son_rapor: Dictionary = {}
var _sure := 0.0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	custom_minimum_size = Vector2(1050, 330)
	position = get_viewport_rect().size / 2.0 - custom_minimum_size / 2.0
	mouse_filter = Control.MOUSE_FILTER_STOP
	var kutu := StyleBoxFlat.new()
	kutu.bg_color = Color("#101923")
	kutu.set_content_margin_all(20)
	add_theme_stylebox_override("panel", kutu)
	var v := VBoxContainer.new()
	add_child(v)
	var baslik := Label.new()
	baslik.text = "Kriz ve sabotaj enjektörü · debug denge varsayımları"
	v.add_child(baslik)
	var aciklama := Label.new()
	aciklama.text = "Veba: herkese enfeksiyon + −40 sağlık; sonraki gecelerde bulaşma ve Şifahane tedavisi. Kuyu: 3 gece boyunca −25 sağlık + hasta.\nKundak: her ambar stok türünden %50 kayıp, yukarı yuvarla; bina hasarı yok.\nGün ilerlemez. Normal üretim/iyileşme/ölüm gece sonunda çalışır.\nKarantina ve dezenfeksiyon sonraki KRI maddeleridir."
	aciklama.add_theme_font_size_override("font_size", 18)
	v.add_child(aciklama)
	var h := HBoxContainer.new()
	v.add_child(h)
	for i in KrizEnjektoru.ISLEMLER.size():
		var b := Button.new()
		b.text = ["Veba tetikle", "Kuyuyu zehirle", "Ambarı kundakla"][i]
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(_tetikle.bind(KrizEnjektoru.ISLEMLER[i]))
		h.add_child(b)
		dugmeler.append(b)
	durum = Label.new()
	durum.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	durum.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(durum)
	var kapat := Button.new()
	kapat.text = "Enjektörü kapat"
	kapat.pressed.connect(func() -> void: ac(false))
	v.add_child(kapat)
	ac(false)

func ac(evet: bool) -> void:
	visible = evet
	set_process(evet)
	if evet: yenile()

func _process(delta: float) -> void:
	_sure += delta
	if _sure >= 0.5:
		_sure = 0.0
		yenile()

func yenile() -> void:
	var uygun := ZamanMakinesi.uygun(baglam) and baglam.get("_ust") == null
	for b in dugmeler: b.disabled = not uygun
	if uygun:
		var o: Oturum = baglam.get("oturum")
		dugmeler[0].disabled = o.yonetim.koylular.is_empty()
		dugmeler[1].disabled = dugmeler[0].disabled or KrizEnjektoru.kalan(o.yonetim) > 0
		dugmeler[2].disabled = o.yonetim.kaynaklar.toplam() == 0
		durum.text = "Kuyu zehri: %d gece kaldı. " % KrizEnjektoru.kalan(o.yonetim)
	else: durum.text = "Kararlı köy gerekli; açık rapor/olay önce tamamlanmalı. "
	if not son_rapor.is_empty():
		durum.text += son_rapor.get("mesaj", son_rapor.get("neden", ""))
		if son_rapor.get("ok", false) and not son_rapor.get("kaydedildi", true): durum.text += " Kayıt yazılamadı."

func _tetikle(id: String) -> void:
	son_rapor = KrizEnjektoru.uygula(baglam, id)
	yenile()
	sonuc_alindi.emit(son_rapor)
