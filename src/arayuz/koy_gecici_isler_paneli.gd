## ISG-02: mevcut köylü kartının sekmesi ve mevcut sürükleme kulpunun hedefleri.
class_name KoyGeciciIslerPaneli
extends RefCounted
class IsHedefi extends Button:
	var ekran: KoyEkrani
	var kisi := -1
	var is_id := ""
	func _can_drop_data(_yer: Vector2, veri: Variant) -> bool:
		return preload("res://src/arayuz/koy_atama_kapisi.gd").acik(ekran) and veri is Dictionary and veri.get("tur") == "koylu_atama" and veri.get("kisi") == kisi and veri.get("oturum") == ekran.oturum.get_instance_id() and GeciciIsler.neden(ekran.oturum.yonetim,ekran.oturum.yonetim.koylu(kisi),is_id).is_empty()
	func _drop_data(yer: Vector2, veri: Variant) -> void:
		if _can_drop_data(yer,veri): KoyGeciciIslerPaneli.ata(ekran,kisi,is_id)

static func ekle(ekran: KoyEkrani, sekmeler: TabContainer, k: Koylu) -> void:
	var v := VBoxContainer.new()
	v.name = TranslationServer.translate("koy.gecici_is.sekme")
	sekmeler.add_child(v)
	var bilgi := ekran._etiket(v,TranslationServer.translate("koy.gecici_is.yonerge"),Tema.KUCUK_PX)
	bilgi.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	for d in GeciciIsler.AYAR.isler:
		var hedef := IsHedefi.new()
		hedef.ekran = ekran
		hedef.kisi = k.id
		hedef.is_id = d.id
		hedef.set_meta("gecici_is",d.id)
		var neden := GeciciIsler.neden(ekran.oturum.yonetim,k,d.id)
		hedef.text = GeciciIsler.ad(d.id)
		hedef.icon = Sanat.is_ikonu(d.id)
		if hedef.icon == null:
			hedef.text = "%s · %s" % [hedef.text.left(1), hedef.text]
		if not neden.is_empty(): hedef.text += " · " + TranslationServer.translate(neden)
		hedef.tooltip_text = TranslationServer.translate("koy.gecici_is.verim") % [int(GeciciIsler.AYAR.verim_yuzde), int(d.yorgunluk)]
		hedef.disabled = not neden.is_empty()
		hedef.pressed.connect(func() -> void: ata(ekran,k.id,d.id))
		v.add_child(hedef)
	if not GeciciIsler.secili(k).is_empty():
		var birak := ekran._dugme(TranslationServer.translate("koy.gecici_is.birak"),v)
		birak.pressed.connect(func() -> void:
			if not preload("res://src/arayuz/koy_atama_kapisi.gd").acik(ekran): return
			GeciciIsler.birak(ekran.oturum.yonetim,k)
			ekran._yenile()
			KoyluKarti.ac(ekran,k.id))

static func ata(ekran: KoyEkrani, kisi: int, is_id: String) -> void:
	if not preload("res://src/arayuz/koy_atama_kapisi.gd").acik(ekran): return
	if not GeciciIsler.ata(ekran.oturum.yonetim,kisi,is_id): return
	ekran.oturum._koy_esitle()
	ekran._yenile()
	KoyluKarti.ac(ekran,kisi)
