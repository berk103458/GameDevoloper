## CHR sorgu ağacı; kilitli JSON diyalog motoruna yazmaz.
extends VBoxContainer

signal karar_istendi
var sorgu: RefCounted

func _ready() -> void:
	sorgu.ipucu_bulundu.connect(func(_ipucu: StringName) -> void: guncelle())
	guncelle()

func guncelle() -> void:
	for cocuk in get_children():
		remove_child(cocuk)
		cocuk.queue_free()
	var dugum: Dictionary = sorgu.karakter.diyalog_dugumu(sorgu.dugum_id)
	var durum := Label.new()
	durum.text = "Tansiyon: %d / 10%s" % [sorgu.tansiyon, " — Panik: barışçıl kabul kapalı" if sorgu.bayraklar["Flag_Kilitlendi"] else ""]
	add_child(durum)
	if not sorgu.son_zar.is_empty():
		var sonuc := Label.new()
		sonuc.text = "%s: %s" % ["İkna" if sorgu.son_zar["beceri"] == "ikna" else "Blöf", "başarılı" if sorgu.son_zar["basarili"] else "başarısız — tansiyon arttı"]
		add_child(sonuc)
	var replik := Label.new()
	replik.text = sorgu.metin(StringName(dugum.get("replik_anahtari", "")))
	replik.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	replik.add_theme_font_size_override("font_size", 23)
	add_child(replik)
	if sorgu.replik_baslat():
		preload("res://src/sistemler/chr_sorgu_sesi.gd").cal(sorgu.karakter, replik.text)
	var secenekler: Array = dugum.get("secenekler", [])
	for i in secenekler.size():
		var secenek: Dictionary = secenekler[i]
		var b := Button.new()
		b.name = "Secenek%d" % i
		b.text = sorgu.metin(StringName(secenek["metin_anahtari"]))
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.custom_minimum_size.y = 80
		b.disabled = not sorgu.secenek_acik(secenek, i)
		if not secenek.get("gerekli_ipuclari", []).is_empty():
			b.tooltip_text = "Önce nişan, yük veya fiziksel izi incele" if b.disabled else "Bulunan kanıtla yüzleş"
			if not b.disabled:
				b.modulate = Color("#e6bd72")
		b.pressed.connect(func() -> void:
			if sorgu.secenek_sec(i):
				guncelle()
		)
		add_child(b)
	if secenekler.is_empty():
		var karar := Button.new()
		var gecis_var: bool = not dugum.get("gecisler", []).is_empty()
		karar.text = "Devam et" if gecis_var else "Kararını ver"
		karar.custom_minimum_size.y = 70
		karar.pressed.connect(func() -> void:
			if gecis_var:
				if sorgu.devam_et():
					guncelle()
			else:
				karar_istendi.emit()
		)
		add_child(karar)
