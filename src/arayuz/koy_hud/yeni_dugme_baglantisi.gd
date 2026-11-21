## OGR-24 oyun bağı: pazar ve divan düğmesine YeniDugmeIsareti takar; ilk görüşte işaret ve tek satır, basınca kalkar.
## Görüldü bilgisi oturumun IpucuKaydi'ndadır; kayıttan dönen oyunda işaret tekrar yanmaz.
class_name YeniDugmeBaglantisi
extends RefCounted


static func kur(sutun: Control, kayit: IpucuKaydi, dugmeler: Dictionary) -> void:
	for id in dugmeler:
		var b: Button = dugmeler[id]
		if b == null:
			continue
		var isaret := YeniDugmeIsareti.new()
		isaret.name = "yeni_dugme_isareti"
		isaret.mouse_filter = Control.MOUSE_FILTER_IGNORE
		isaret.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		b.add_child(isaret)
		var sonuc := isaret.dugme_etkinlesti(String(id), kayit)
		var satir: Label = null
		if int(sonuc.isaret) == 1:
			satir = Label.new()
			satir.name = "yeni_dugme_satiri_%s" % id
			satir.text = String(sonuc.metin)
			var ipucu_px := maxi(13, Tema.KUCUK_PX - 5)
			satir.add_theme_font_size_override("font_size", ipucu_px)
			satir.autowrap_mode = TextServer.AUTOWRAP_OFF
			satir.clip_text = true
			satir.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			satir.tooltip_text = String(sonuc.metin)
			sutun.add_child(satir)
			if b.get_parent() == sutun:
				sutun.move_child(satir, b.get_index() + 1)
			elif b.get_parent() != null and b.get_parent().get_parent() == sutun:
				sutun.move_child(satir, b.get_parent().get_index() + 1)
			if isaret.is_inside_tree():
				var tw := isaret.create_tween()
				tw.tween_property(isaret, "modulate:a", 0.2, 0.4)
				tw.tween_property(isaret, "modulate:a", 1.0, 0.4)
		b.pressed.connect(func() -> void:
			isaret.dugmeye_girildi(String(id))
			if is_instance_valid(satir):
				satir.queue_free()
		)
