## DYL-01: Beyan defteri ve çelişki yüzleştirme ("Göster") paneli.
class_name BeyanDefteriPaneli
extends PanelContainer

signal yuzlesildi(sonuc: Dictionary)
signal kapandi

var celiski: Celiski
var motor: SozMotoru
var defter: BeyanDefteri
var sorgu: RefCounted
var oturum: Oturum
var gelen_id: String = ""

var _secili: Array[String] = []
var _liste: VBoxContainer
var _durum: Label
var _goster: Button


func _ready() -> void:
	name = "BeyanDefteriPaneli"
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	custom_minimum_size = Vector2(540, 420)
	z_index = 25
	var dis := VBoxContainer.new()
	dis.add_theme_constant_override("separation", 10)
	add_child(dis)

	var baslik := Label.new()
	baslik.name = "Baslik"
	baslik.text = "Beyan Defteri · Çelişki Göster"
	baslik.add_theme_font_size_override("font_size", Kabuk.BASLIK)
	dis.add_child(baslik)

	var kaydir := ScrollContainer.new()
	kaydir.custom_minimum_size = Vector2(500, 230)
	kaydir.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dis.add_child(kaydir)

	_liste = VBoxContainer.new()
	_liste.name = "KayitListesi"
	_liste.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_liste.add_theme_constant_override("separation", 6)
	kaydir.add_child(_liste)

	_durum = Label.new()
	_durum.name = "DurumYazisi"
	_durum.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dis.add_child(_durum)

	var alt := HBoxContainer.new()
	alt.add_theme_constant_override("separation", 8)
	dis.add_child(alt)

	_goster = Button.new()
	_goster.name = "GosterDugmesi"
	_goster.text = "Göster"
	_goster.custom_minimum_size = Vector2(160, 48)
	_goster.pressed.connect(_goster_tiklandi)
	alt.add_child(_goster)

	var kapat := Button.new()
	kapat.name = "KapatDugmesi"
	kapat.text = "Kapat"
	kapat.custom_minimum_size = Vector2(120, 48)
	kapat.pressed.connect(func() -> void:
		kapandi.emit()
		queue_free()
	)
	alt.add_child(kapat)
	guncelle()


func kur(ctx: Dictionary) -> void:
	celiski = ctx.get("celiski") as Celiski
	motor = ctx.get("motor") as SozMotoru
	defter = ctx.get("defter") as BeyanDefteri
	sorgu = ctx.get("sorgu")
	oturum = ctx.get("oturum") as Oturum
	gelen_id = String(ctx.get("gelen_id", ""))
	if celiski == null:
		celiski = Celiski.new()
	if is_inside_tree():
		guncelle()


func guncelle() -> void:
	if _liste == null:
		return
	for c in _liste.get_children():
		_liste.remove_child(c)
		c.queue_free()
	if celiski == null:
		celiski = Celiski.new()
	var kayitlar := celiski.kayitlari_al_oturumla(motor, defter, sorgu, oturum, gelen_id)
	for k in kayitlar:
		var kid := String(k.get("id", ""))
		var tur_kod := String(k.get("tur", ""))
		var tur := "İpucu" if tur_kod == "ipucu" else "Beyan"
		var kaynak := String(k.get("kaynak", ""))
		var metin := String(k.get("metin", kid))
		var cozuldu := bool(k.get("cozuldu", false))
		var b := Button.new()
		b.name = "Kayit_" + kid
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.custom_minimum_size.y = 48
		b.toggle_mode = true
		b.button_pressed = kid in _secili
		var etiket := "[%s · %s] %s" % [tur, kaynak, metin]
		if tur_kod == "soylenti":
			var soz := String(k.get("etiket", kaynak))
			etiket = soz if metin.is_empty() or metin == soz else "%s %s" % [soz, metin]
		b.text = ("✓ [Çözüldü] " + etiket) if cozuldu else etiket
		b.disabled = cozuldu
		b.pressed.connect(_kayit_sec.bind(kid))
		_liste.add_child(b)
	_goster_durumu_guncelle(kayitlar.size())


func kayit_sec_kimlikle(kid: String) -> void:
	_kayit_sec(kid)


func goster_bas() -> Dictionary:
	return _goster_tiklandi()


func _kayit_sec(kid: String) -> void:
	if kid in _secili:
		_secili.erase(kid)
	else:
		if _secili.size() >= 2:
			_secili.pop_front()
		_secili.append(kid)
	guncelle()


func _goster_tiklandi() -> Dictionary:
	if _secili.size() != 2 or celiski == null:
		return {"basarili": false, "sebep": "iki_kayit_sec"}
	var sonuc := celiski.yuzles(_secili[0], _secili[1], {
		"motor": motor,
		"defter": defter,
		"sorgu": sorgu,
		"oturum": oturum,
		"gelen_id": gelen_id,
	})
	_secili.clear()
	guncelle()
	if bool(sonuc.get("basarili", false)):
		_durum.text = String(sonuc.get("satir", "Çelişki yakalandı!"))
	elif bool(sonuc.get("goster_kapali", false)):
		_durum.text = "3 yanlıştan sonra Göster bu ziyarette kapandı."
	else:
		_durum.text = String(sonuc.get("tepki", Celiski.VARSAYILAN_TEPKI))
	yuzlesildi.emit(sonuc)
	return sonuc


func _goster_durumu_guncelle(kayit_sayisi: int) -> void:
	if celiski.goster_kapali or celiski.yanlis_sayisi >= Celiski.AZAMI_YANLIS:
		_goster.disabled = true
		if _durum.text.is_empty():
			_durum.text = "3 yanlıştan sonra Göster bu ziyarette kapandı."
	elif kayit_sayisi <= 1:
		_goster.disabled = true
		_durum.text = "Çelişki göstermek için en az iki kayıt gerekir."
	else:
		_goster.disabled = _secili.size() != 2
		if _durum.text.is_empty():
			_durum.text = "İki kayıt seçip Göster'e bas (%d/%d)." % [_secili.size(), 2]
