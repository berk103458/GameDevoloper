## SAB-75: hüküm satırı köy ekranında. Ayrı sabah sahnesi yok.
## Ayar anahtarı yalnız mevcut `rapor_bekle`; ikinci anahtar açılmaz.
extends PanelContainer

const AYAR := "rapor_bekle"

var ekran: Node


static func kur(hedef: Node) -> PanelContainer:
	var p := preload("res://src/arayuz/koy_hud/sabah_paneli.gd").new()
	p.ekran = hedef
	hedef.add_child(p)
	return p


static func ayar_anahtari() -> String:
	return AYAR


func _ready() -> void:
	visible = false
	var yonetim: Variant = null
	if ekran != null:
		var oturum: Variant = ekran.get("oturum")
		if oturum == null and ekran.has_meta(&"oturum"):
			oturum = ekran.get_meta(&"oturum")
		if oturum != null:
			yonetim = oturum.get("yonetim")
			if yonetim == null and oturum.has_meta(&"yonetim"):
				yonetim = oturum.get_meta(&"yonetim")
	if yonetim == null:
		return
	var d: Dictionary = preload("res://src/koy/sabah_defteri.gd").durum(yonetim)
	if d.satirlar.is_empty():
		return
	visible = true
	var yazi := Label.new()
	yazi.text = String(d.satirlar[0].get("anahtar", "sabah.hukum.satir"))
	add_child(yazi)


func bekler_mi() -> bool:
	if ekran == null:
		return true
	var a: Variant = ekran.get("ayarlar")
	if a == null:
		return true
	return bool(a.degerler.get(AYAR, true)) if a.get("degerler") is Dictionary else true
