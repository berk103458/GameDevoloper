## Dünya görünümü sürükle-bırak hedefi; görünüm ve eski dünya girdileri korunur.
class_name KoyAtamaAlani
extends Control
var ekran: KoyEkrani
var onizleme: PanelContainer
var aciklama: Label
var son: Dictionary = {}
func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 90
	hide()
	onizleme = PanelContainer.new()
	onizleme.mouse_filter = Control.MOUSE_FILTER_IGNORE
	onizleme.z_index = 100
	onizleme.custom_minimum_size.x = 390
	onizleme.hide()
	add_child(onizleme)
	aciklama = Label.new()
	aciklama.mouse_filter = Control.MOUSE_FILTER_IGNORE
	aciklama.add_theme_font_size_override("font_size", 20)
	onizleme.add_child(aciklama)
func veri_gecerli(veri: Variant) -> bool:
	return veri is Dictionary and veri.get("tur") == "koylu_atama" and veri.get("kisi") is int and veri.get("oturum") == ekran.oturum.get_instance_id()
func hedef(yer: Vector2) -> int:
	var h := ekran.sahne3b.isaret(ekran._vp_konum(yer))
	var b := ekran._bina_altinda(h)
	return b.id if b != null else -1
func _birakma_onizlemesi(kisi: int, id: int) -> Dictionary:
	var y := ekran.oturum.yonetim
	var sonuc := AtamaOnizlemesi.oku(y, kisi, id)
	if sonuc.olur and sonuc.uyum < 1.0:
		sonuc.olur = false
		sonuc.neden = TranslationServer.translate("koy.atama.meslek_uyusmaz")
	return sonuc

func _can_drop_data(yer: Vector2, veri: Variant) -> bool:
	if not veri_gecerli(veri): return false
	var id := hedef(yer)
	son = _birakma_onizlemesi(veri.kisi, id)
	if not ekran.kip.is_empty():
		son.olur = false
		son.neden = "Önce inşaat/yol/yıkım kipini kapatın"
	aciklama.text = AtamaOnizlemesi.metin(son)
	aciklama.modulate = Color(0.45, 1.0, 0.55) if son.yesil and son.olur else Color(1.0, 0.45, 0.40)
	onizleme.position = Vector2(clampf(yer.x + 16, 0, maxf(0, ekran.size.x - 410)), clampf(yer.y + 16, 0, maxf(0, ekran.size.y - 190)))
	onizleme.show()
	return son.olur
func _drop_data(yer: Vector2, veri: Variant) -> void:
	if not veri_gecerli(veri) or not ekran.kip.is_empty(): return
	var id := hedef(yer)
	var yeni := _birakma_onizlemesi(veri.kisi, id)
	if yeni.olur: KoyluKarti._ata(ekran, veri.kisi, id)
	onizleme.hide()
func _notification(ne: int) -> void:
	if not is_instance_valid(ekran): return
	if ne == NOTIFICATION_DRAG_BEGIN:
		if veri_gecerli(get_viewport().gui_get_drag_data()): show()
		return
	if ne != NOTIFICATION_DRAG_END: return
	hide()
	if is_instance_valid(onizleme): onizleme.hide()
	if is_instance_valid(ekran._ust_kart): ekran._ust_kart.show()
