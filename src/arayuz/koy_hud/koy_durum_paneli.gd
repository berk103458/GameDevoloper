## Köyün hâli: dört bar (Halk, Soylular, Tüccarlar, Ordu) ve ambarın kaç gece yeteceği.
## Bar 2 ve altına inince dolgu kırmızılaşır (kırılmaya yakın).
class_name KoyDurumPaneli
extends PanelContainer

const BAR_SIMGE := ["person", "crown", "shop", "crossed-swords"]

var oturum: Oturum
var _cubuklar: Array[ProgressBar] = []
var _farklar: Array[Label] = []
var _ambar: ProgressBar
var _ambar_yazi: Label
var _kirmizi: StyleBoxFlat
var _bronz: StyleBoxFlat


func _ready() -> void:
	custom_minimum_size = Vector2(380, 0)
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 14)
	add_child(kenar)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	kenar.add_child(v)
	var b := HudYardim.etiket(tr("arayuz.durum.baslik"), &"Baslik", 28)
	v.add_child(b)
	_bronz = StyleBoxFlat.new()
	_bronz.bg_color = Renkler.BRONZ
	_kirmizi = StyleBoxFlat.new()
	_kirmizi.bg_color = Renkler.EKSI.darkened(0.15)
	for i in oturum.ayarlar.bar_anahtarlari.size():
		var satir := HBoxContainer.new()
		satir.add_theme_constant_override("separation", 10)
		satir.add_child(HudYardim.simge(BAR_SIMGE[i % BAR_SIMGE.size()], 30.0))
		var ad := HudYardim.etiket(tr(oturum.ayarlar.bar_anahtarlari[i]), &"", 22)
		ad.custom_minimum_size.x = 120
		satir.add_child(ad)
		var c := ProgressBar.new()
		c.min_value = 0
		c.max_value = oturum.barlar.azami
		c.show_percentage = false
		c.custom_minimum_size = Vector2(130, 16)
		c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		c.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		satir.add_child(c)
		var f := HudYardim.etiket("", &"", 18)
		f.custom_minimum_size.x = 34
		satir.add_child(f)
		v.add_child(satir)
		_cubuklar.append(c)
		_farklar.append(f)
	v.add_child(HSeparator.new())
	var a := HBoxContainer.new()
	a.add_theme_constant_override("separation", 10)
	a.add_child(HudYardim.simge("barn", 30.0))
	_ambar = ProgressBar.new()
	_ambar.show_percentage = false
	_ambar.custom_minimum_size = Vector2(200, 16)
	_ambar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_ambar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	a.add_child(_ambar)
	v.add_child(a)
	_ambar_yazi = HudYardim.etiket("", &"", 20)
	_ambar_yazi.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(_ambar_yazi)
	guncelle()


func guncelle() -> void:
	if oturum == null or _cubuklar.is_empty():
		return
	var once: Array = oturum.onceki_durum.get("barlar", [])
	for i in _cubuklar.size():
		var d := int(oturum.barlar.degerler[i])
		_cubuklar[i].value = d
		_cubuklar[i].add_theme_stylebox_override("fill", _kirmizi if d <= 2 else _bronz)
		HudYardim.fark_yaz(_farklar[i], d - (int(once[i]) if i < once.size() else d))
	var t := oturum.ambar_tahmini()
	var net: int = int(t["uretim"]) - int(t["tuketim"])
	_ambar.max_value = maxi(maxi(int(t["tuketim"]) * 6, oturum.ambar), 1)
	_ambar.value = oturum.ambar
	if net >= 0:
		_ambar_yazi.text = tr("arayuz.durum.ambar_artar") % net
	elif oturum.ambar <= 0:
		_ambar_yazi.text = tr("arayuz.durum.ambar_bos")
	else:
		_ambar_yazi.text = tr("arayuz.durum.ambar_yeter") % ceili(oturum.ambar / float(-net))
	_ambar_yazi.add_theme_color_override("font_color", Renkler.EKSI if net < 0 and oturum.ambar < -net * 3 else Renkler.PARSOMEN)
