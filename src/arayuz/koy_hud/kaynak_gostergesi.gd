## Köy HUD'unun üst şeridi: akçe, ambar, nüfus (asker/esnaf/çiftçi), rüşvet kesesi; sağda gün, perde, saat.
## Her değerin yanında son köy görünümünden bu yana fark (+ yeşil / − kırmızı).
class_name KaynakGostergesi
extends PanelContainer

## [anahtar, simge, ipucu anahtarı]
const KALEMLER := [
	["akce", "two-coins", "arayuz.kaynak.akce"],
	["ambar", "barn", "arayuz.kaynak.ambar"],
	["nufus", "village", "arayuz.kaynak.nufus"],
	["asker", "crossed-swords", "arayuz.kaynak.asker"],
	["esnaf", "anvil", "arayuz.kaynak.esnaf"],
	["ciftci", "farmer", "arayuz.kaynak.ciftci"],
	["kese", "swap-bag", "arayuz.kaynak.kese"],
]

var oturum: Oturum
var _degerler: Dictionary = {}
var _farklar: Dictionary = {}
var _takvim: Label
var _saat: Label


func _ready() -> void:
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right"]:
		kenar.add_theme_constant_override(y, 18)
	for y in ["margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 2)
	add_child(kenar)
	var satir := HBoxContainer.new()
	satir.add_theme_constant_override("separation", 30)
	kenar.add_child(satir)
	for k in KALEMLER:
		var kutu := HBoxContainer.new()
		kutu.add_theme_constant_override("separation", 8)
		kutu.tooltip_text = tr(k[2])
		kutu.mouse_filter = Control.MOUSE_FILTER_PASS
		kutu.add_child(HudYardim.simge(k[1], 34.0))
		var d := HudYardim.etiket("0", &"Sayi")
		kutu.add_child(d)
		var f := HudYardim.etiket("", &"", 18)
		f.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		kutu.add_child(f)
		satir.add_child(kutu)
		_degerler[k[0]] = d
		_farklar[k[0]] = f
	var bosluk := Control.new()
	bosluk.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	satir.add_child(bosluk)
	satir.add_child(HudYardim.simge("moon", 30.0))
	_takvim = HudYardim.etiket("", &"Sayi")
	satir.add_child(_takvim)
	satir.add_child(HudYardim.simge("sundial", 30.0))
	_saat = HudYardim.etiket("", &"Sayi")
	_saat.custom_minimum_size.x = 96
	satir.add_child(_saat)
	guncelle(16.5)


## Değerleri oturumdan, saati köy saatinden yeniler.
func guncelle(saat: float) -> void:
	if oturum == null or _degerler.is_empty():
		return
	var simdi := oturum.anlik_durum()
	var once: Dictionary = oturum.onceki_durum
	for k in _degerler:
		(_degerler[k] as Label).text = str(simdi[k])
		HudYardim.fark_yaz(_farklar[k], int(simdi[k]) - int(once.get(k, simdi[k])))
	_takvim.text = tr("arayuz.koy.takvim") % oturum.gun + "  ·  " + tr("arayuz.koy.perde") % oturum.perde
	var s := int(saat) % 24
	_saat.text = tr("arayuz.koy.saat") % [s, int(fmod(saat, 1.0) * 60.0)]
