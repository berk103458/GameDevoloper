## KAP-39: Heybe paneli açıkken soru seçilmez, kalan hak düşmez, karar uygulanmaz, sorgu eylemi kilitlenir.
extends Node

var _hata := 0


func dene(kosul: bool, mesaj: String) -> void:
	if kosul:
		return
	_hata += 1
	push_error("KAP-39 HATA: " + mesaj)


func _hazir_ekran(kat: Katalog, tohum: int) -> Dictionary:
	var o := Oturum.new(kat, tohum)
	o.gun = 3
	var ke := KapiEkrani.new()
	ke.oturum = o
	ke.ayarlar = Ayarlar.new("user://unused_kap39.cfg")
	add_child(ke)
	return {"o": o, "ke": ke}


func _ready() -> void:
	get_tree().create_timer(25.0).timeout.connect(func() -> void: get_tree().quit(1))
	var kat := Katalog.new()
	kat.yukle()

	# 1. Adsiz gelen: sohbet & karar sirasinda heybe acikken soru hakki dusmez, dal acilmaz, karar uygulanmaz.
	var ctx := _hazir_ekran(kat, 1901)
	var o: Oturum = ctx.o
	var ke: KapiEkrani = ctx.ke
	await get_tree().process_frame
	var g := o._figur_sablon()
	g.heybe = o.heybe_uret(g.sinif)
	g.sorular = [
		PackedStringArray(["Soru 1", "Cevap 1"]),
		PackedStringArray(["Takip 1", "Cevap Takip 1"]),
	]
	g.soru_ust = PackedInt32Array([-1, 0])
	ke._gelen = g
	ke._sorulan = []
	ke._sohbet_goster()
	var bas_secenek := ke._secenekler.get_child(0) as Button
	var secenek_sayisi_once := ke._secenekler.get_child_count()
	var once_sorulan := ke._sorulan.size()
	var kalan_once := g.soru_siniri(o.ayarlar.azami_soru) - ke._sorulan.size()

	ke._heybe_ac()
	await get_tree().process_frame
	dene(ke.heybe_acik_mi(), "Heybe paneli acik olmali")
	bas_secenek.pressed.emit()
	ke._soru_sor(0)
	dene(ke._sorulan.size() == once_sorulan, "Heybe acikken soru secilince _sorulan artmaz")
	dene(ke._secenekler.get_child_count() == secenek_sayisi_once, "Heybe acikken takip sorusu (yeni dal) acilmaz")
	ke._karar_bas("kabul")
	ke._karar_ver("kabul")
	dene(o.yonetim.kabul_sayisi == 0, "Heybe acikken karar etki yazmaz")

	ke._heybe_paneli._kapat.pressed.emit()
	await get_tree().process_frame
	dene(not ke.heybe_acik_mi(), "Heybe kapandi")
	dene(is_instance_valid(bas_secenek), "Heybe kapaninca ayni soru dugmesi durur")
	var kalan_sonra := g.soru_siniri(o.ayarlar.azami_soru) - ke._sorulan.size()
	dene(kalan_sonra == kalan_once, "Panel kapaninca kalan soru hakki ayni sayidadir")

	# 2. Adli CHR gelen: sorgu eylemi heybe acikken secilmez; kapaninca ayni dugme durur.
	ke._karar_goster()
	ke._heybe_ac()
	await get_tree().process_frame
	ke._karar_bas("kabul")
	ke._karar_bas("kabul")
	dene(o.yonetim.kabul_sayisi == 0, "Karar fazinda heybe acikken cift tik karar yazmaz")
	ke._heybe_paneli._kapat.pressed.emit()
	await get_tree().process_frame

	var chr_g := o._adli_gelen(&"chr_001")
	chr_g.heybe = o.heybe_uret(chr_g.sinif)
	ke._gelen = chr_g
	ke._sorulan = []
	ke._sohbet_goster()
	await get_tree().process_frame
	var chr_panel: Node = ke._secenekler.get_child(0)
	var sorgu := chr_g.chr_sorgusu()
	var bas_dugum := String(sorgu.dugum_id)
	var ilk_eylem: Button = null
	for child in chr_panel.get_children():
		if child is Button and String(child.name).begins_with("Secenek") and not child.disabled:
			ilk_eylem = child
			break
	if ilk_eylem == null:
		print("CHR PANEL CHILDREN: ", chr_panel.get_children().map(func(c: Node) -> String: return "%s:%s" % [c.name, c.get("text")]))
	dene(ilk_eylem != null, "CHR sorgu eylem dugmesi bulunmali")

	ke._heybe_ac()
	await get_tree().process_frame
	dene(ke.heybe_acik_mi(), "CHR sohbetinde heybe acik")
	ilk_eylem.pressed.emit()
	dene(String(sorgu.dugum_id) == bas_dugum and sorgu._denemeler.is_empty() and sorgu.son_zar.is_empty(), "Heybe acikken sorgu eylemi secilmez")

	ke._heybe_paneli._kapat.pressed.emit()
	await get_tree().process_frame
	dene(is_instance_valid(ilk_eylem), "Panel kapaninca ayni sorgu eylem dugmesi durur")

	ke.queue_free()
	await get_tree().process_frame
	print("HEYBE KILIT: %s" % ("GEÇTİ" if _hata == 0 else "KALDI (%d hata)" % _hata))
	get_tree().quit(0 if _hata == 0 else 1)
