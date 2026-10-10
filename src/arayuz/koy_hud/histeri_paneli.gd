## HUD -> Node ördek tiplemesi; KoyEkrani/autoload statik bağımlılığı yok.
extends RefCounted
const H = preload("res://src/koy/batil_inanc_histerisi.gd")

static func hud(h: Node, y: KoyYonetimi) -> void:
	var ust: Node = h._huzur_bar.get_parent()
	var b := ust.get_node_or_null("histeri_karari") as Button
	if b == null:
		b = Button.new()
		b.name = "histeri_karari"
		b.text = "Haksız söylentiyi durdur"
		ust.add_child(b)
		b.pressed.connect(func() -> void:
			var e := AmbarKapisiPaneli._ekran(h)
			if e == null or AmbarKapisiPaneli._kilitli(e): return
			ac(e)
		)
	var e := AmbarKapisiPaneli._ekran(h)
	b.visible = H.bekliyor(y)
	b.disabled = e == null or AmbarKapisiPaneli._kilitli(e)
	b.tooltip_text = H.metin(y)

static func ac(e: Node) -> void:
	var olay: OlayVerisi = H.olay(e.oturum)
	if olay == null: return
	var v: VBoxContainer = e._kart_ac(olay.baslik_anahtari)
	var l: Label = e._etiket(v, olay.metin_anahtari, Tema.KUCUK_PX)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = 680
	for idx in olay.secenek_anahtarlari.size():
		var b: Button = e._dugme(olay.secenek_anahtarlari[idx], v)
		b.name = "histeri_" + H.SECIMLER[idx]
		b.disabled = not H.uygun(e.oturum, olay, idx)
		b.pressed.connect(func() -> void:
			var r: Dictionary = H.uygula(e.oturum, olay, idx)
			if not r.ok: return
			var sonuc: VBoxContainer = e._kart_ac("Söylenti kararı")
			var metin: Label = e._etiket(sonuc, r.sonuc_anahtari, Tema.KUCUK_PX)
			metin.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			metin.custom_minimum_size.x = 680
			_don(e, sonuc)
			e._yenile()
		)
	_don(e, v)

static func _don(e: Node, v: Control) -> void:
	var b: Button = e._dugme("Köye dön", v)
	b.name = "histeri_don"
	b.pressed.connect(func() -> void:
		e._kart_kapat()
		e._yenile()
	)
