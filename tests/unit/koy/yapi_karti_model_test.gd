## YAP-62: yapı kartları gerçek köy ekranında çizilip üzerine gelinip basılınca köy sahnesindeki
## 3B yapı ve köylü meshleri değişmez. Yerleşim önizlemesi (hayalet) ve seçim kutusu karşılaştırmaya girmez.
extends SceneTree

var hata := 0
var kontrol_sayisi := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	create_timer(90.0).timeout.connect(func() -> void: quit(1))
	root.size = Vector2i(1920, 1080)
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 62)
	o.yonetim.kabul({"ad": "Kart deneği", "sinif": "ciftci"})
	var ekran: Control = load("res://src/arayuz/koy_ekrani.gd").new()
	ekran.oturum = o
	ekran.ayarlar = Ayarlar.new("user://yap62_unused.cfg")
	ekran.theme = Tema.olustur(ekran.ayarlar)
	root.add_child(ekran)
	await process_frame
	await process_frame
	ekran._hiz_sec(0)
	var s: KoyYonetimSahnesi = ekran.sahne3b
	s.halk_hareketi.set_process(false)
	await process_frame
	var once := _meshler(s)
	var kayit_once := JSON.stringify(o.kaydet())
	_kontrol(once.size() > 0, "YAP-62: köy sahnesinde ölçülecek mesh var (%d)" % once.size())

	var kart_sayisi := 0
	var basilan := 0
	for k in ekran.KATEGORILER:
		var kategori_dugmesi := _kategori_dugmesi(ekran, k)
		_kontrol(kategori_dugmesi != null, "YAP-62: %s kategori düğmesi bulunur" % k)
		if kategori_dugmesi == null:
			continue
		await _tikla(kategori_dugmesi)
		for kart in ekran._yapi_satiri.get_children():
			if kart.get_script() == null or kart.get_script().resource_path != "res://src/arayuz/koy_hud/yapi_karti.gd" or not kart.is_visible_in_tree():
				continue
			kart_sayisi += 1
			var orta := (kart as Control).get_global_rect().get_center()
			var hareket := InputEventMouseMotion.new()
			hareket.position = orta
			hareket.global_position = orta
			root.push_input(hareket, true)
			await process_frame
			if not kart.disabled:
				await _tikla(kart)
				if ekran.kip == "insa":
					basilan += 1
				ekran._kip_sec("")
				await process_frame
	await process_frame
	await process_frame
	_kontrol(kart_sayisi > 0, "YAP-62: dört kategoride gerçek yapı kartı çizildi (%d)" % kart_sayisi)
	_kontrol(basilan > 0, "YAP-62: en az bir karta fareyle basılıp inşa kipine girildi (%d)" % basilan)
	var sonra := _meshler(s)
	var fark := 0
	for yol in once:
		if not sonra.has(yol) or sonra[yol] != once[yol]:
			fark += 1
	for yol in sonra:
		if not once.has(yol):
			fark += 1
	_kontrol(fark == 0, "YAP-62: kartlar sonrası mesh farkı 0 (%d fark / %d mesh)" % [fark, once.size()])
	_kontrol(not s._hayalet.visible, "YAP-62: kip kapanınca yerleşim önizlemesi gizlenir")
	_kontrol(JSON.stringify(o.kaydet()) == kayit_once, "YAP-62: kartlar kaydı değiştirmez")
	print("YAP-62 KART MODEL: GEÇTİ (%d kontrol)" % kontrol_sayisi if hata == 0 else "YAP-62 KART MODEL: KALDI (%d hata / %d kontrol)" % [hata, kontrol_sayisi])
	quit(1 if hata > 0 else 0)


func _meshler(s: KoyYonetimSahnesi) -> Dictionary:
	var sonuc := {}
	for m in s.find_children("*", "MeshInstance3D", true, false):
		if m == s._hayalet or m == s._secim:
			continue
		var mi := m as MeshInstance3D
		sonuc[str(s.get_path_to(mi))] = [mi.mesh.get_rid() if mi.mesh else RID(), mi.material_override.get_rid() if mi.material_override else RID(), mi.visible, mi.global_transform]
	return sonuc


func _kategori_dugmesi(ekran: Control, k: String) -> Button:
	for c in ekran._kategori_satiri.get_children():
		if c is Button and c.text == TranslationServer.translate("koy.kategori." + k):
			return c
	return null


func _tikla(c: Control) -> void:
	var p := c.get_global_rect().get_center()
	for bas in [true, false]:
		var e := InputEventMouseButton.new()
		e.position = p
		e.global_position = p
		e.button_index = MOUSE_BUTTON_LEFT
		e.pressed = bas
		e.button_mask = MOUSE_BUTTON_MASK_LEFT if bas else 0
		root.push_input(e, true)
		await process_frame


func _kontrol(v: bool, ad: String) -> void:
	kontrol_sayisi += 1
	if not v:
		hata += 1
		push_error(ad)
