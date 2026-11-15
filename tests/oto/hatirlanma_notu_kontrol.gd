## DIY-14: Gerçek KapiEkrani karar akışında HatirlanmaNotu bağlantısı kontrolü.
extends Node

var _hata := 0


func _dene(ok: bool, mesaj: String) -> void:
	if not ok:
		_hata += 1
		push_error(mesaj)


func _ready() -> void:
	get_tree().create_timer(25.0).timeout.connect(func() -> void: get_tree().quit(1))
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 914)
	var kok := Control.new()
	kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var a := Ayarlar.new("user://unused_diy14.cfg")
	a.degerler[&"belirme_hizi"] = &"aninda"
	a.degerler[&"hatirlanma_notu"] = true
	kok.theme = Tema.olustur(a)
	add_child(kok)

	var ekran := KapiEkrani.new()
	ekran.oturum = o
	ekran.ayarlar = a
	kok.add_child(ekran)

	# 1. Adlı ziyaretçide karar -> KisiHafizasi yazılır -> HatirlanmaNotu görünür ve adı/geceyi içermez.
	var g := o._adli_gelen(&"chr_001")
	g.heybe = Heybe.new()
	ekran._gelen = g
	ekran._karar_goster()
	await get_tree().process_frame
	ekran._karar_ver("ret")
	await get_tree().process_frame

	var not_ui := ekran.get_node_or_null("HatirlanmaNotu")
	_dene(not_ui != null, "HatirlanmaNotu düğümü KapiEkrani içinde oluşturulmalı")
	if not_ui != null:
		_dene(not_ui.visible and String(not_ui.call("metin_oku")) == "Bu hatırlanacak", "Karar sonrası 'Bu hatırlanacak' notu ekranda görünmeli")
		_dene(int(not_ui.call("gorunme_sayisi")) == 1 and int(not_ui.call("aktif_not_sayisi")) == 1, "Tek kararda not tam 1 kez görünmeli")
		var kayit := KisiHafizasi.oku(o.kadro, &"chr_001", o.gun)
		_dene((kayit.get("karar_gecmisi", []) as Array).size() >= 1, "Oturum.karar_ver adlı kişinin karar_gecmisi kaydını yazmalı")
		# Tıklayınca kapanır
		not_ui.call("tikla")
		_dene(not not_ui.visible, "Tıklanınca HatirlanmaNotu hemen kapanmalı")

	# 2. Ayar kapalıyken not 0 kez görünür ama hafıza yine yazılır.
	a.degerler[&"hatirlanma_notu"] = false
	var g2 := o._adli_gelen(&"chr_002")
	g2.heybe = Heybe.new()
	ekran._gelen = g2
	ekran._karar_goster()
	await get_tree().process_frame
	ekran._karar_ver("ret")
	await get_tree().process_frame
	if not_ui != null:
		_dene(not not_ui.visible and int(not_ui.call("gorunme_sayisi")) == 1, "Ayar kapalıyken HatirlanmaNotu 0 kez daha görünmeli")
	var kayit2 := KisiHafizasi.oku(o.kadro, &"chr_002", o.gun)
	_dene((kayit2.get("karar_gecmisi", []) as Array).size() >= 1, "Ayar kapalıyken dahi KisiHafizasi kaydı yazılmalı")

	kok.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("HATIRLANMA NOTU UI: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	await Ses.cik(_hata)
