## KRI-06: mevcut HUD ambar çubuğu ve ambar bina bilgisi, tek onarım yüzeyi.
class_name AmbarKapisiPaneli
extends RefCounted

## hud.gd bu dosyayı yükler; KoyEkrani tipini (ve onun Ses autoload'unu) statik
## bağımlılığa çekmemek için ekran ördek tipleme ile bulunur (-s birim testleri).
static func _ekran(n: Node) -> Node:
	while n != null:
		if "_ust_kart" in n and "_gece_kilidi" in n: return n
		n = n.get_parent()
	return null

static func _kilitli(e: Node) -> bool:
	return e != null and (e._ust_kart != null or e._gece_kilidi.kilitli())

## Açık raporda gündüz bedeli bilanço kapanışını değiştirmez.
static func kart_durumu(e: Node) -> void:
	if e.hud != null: e.hud.guncelle()

static func hud(h: Hud, y: KoyYonetimi) -> void:
	h._ambar_bar.tooltip_text += "\n" + KitlikIsyani.metin(y)
	var b := h._ambar_bar.get_parent().get_node_or_null("ambar_kapisi_onar") as Button
	if b == null:
		b = Button.new()
		b.name = "ambar_kapisi_onar"
		b.text = "Ambar kapısını onar"
		h._ambar_bar.get_parent().add_child(b)
		b.pressed.connect(func() -> void:
			var e := _ekran(h)
			if _kilitli(e): return
			if KitlikIsyani.onar(h._oturum.yonetim):
				h._oturum.koy.degisti.emit()
				if e != null: e._yenile()
		)
	b.visible = KitlikIsyani.durum(y).kapi_kirik
	var kilitli := _kilitli(_ekran(h))
	b.disabled = kilitli or not KitlikIsyani.onarim_nedeni(y).is_empty()
	b.tooltip_text = "Önce açık raporu/kararı tamamla" if kilitli else (KitlikIsyani.onarim_nedeni(y) if b.disabled else "4 taş + 6 kereste · kapasite ve korumayı geri getirir")

static func ekle(e: Node, b: KoyBinasi) -> void:
	if b.tur != "ambar": return
	var y: KoyYonetimi = e.oturum.yonetim
	var l: Label = e._etiket(e._bilgi_icerik, KitlikIsyani.metin(y), Tema.KUCUK_PX)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if not KitlikIsyani.durum(y).kapi_kirik: return
	var d: Button = e._dugme("Ambar kapısını onar (4 taş + 6 kereste)", e._bilgi_icerik)
	d.name = "ambar_bilgi_onar"
	d.disabled = _kilitli(e) or not KitlikIsyani.onarim_nedeni(y).is_empty()
	d.tooltip_text = KitlikIsyani.onarim_nedeni(y)
	d.pressed.connect(func() -> void:
		if _kilitli(e): return
		if KitlikIsyani.onar(y):
			e.oturum.koy.degisti.emit()
			e._yenile()
	)
