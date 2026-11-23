## Ana menü ve yeni oyun köy sahnesi yüklenir. SCRIPT ERROR / eksik kaynak = çıkış 1.
extends Node

const TEST_YUVA_KOK := "user://test_acilis_menu_yuva/"

var hata := 0

func _ready() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	get_tree().create_timer(90.0).timeout.connect(func() -> void: get_tree().quit(1))
	_test_yuvayi_temizle()
	for ad in Dunya3B.TOPLULUK_YER:
		dene(ResourceLoader.exists(Dunya3B.TOPLULUK_YER[ad]), "Kaynak var: %s" % ad)
	var pak := load("res://src/arayuz/ana.tscn") as PackedScene
	dene(pak != null, "Ana menü sahnesi yüklenir")
	if pak == null:
		_bitir()
		return
	var ana := pak.instantiate() as Ana
	add_child(ana)
	var menu: MenuEkrani = null
	for _i in 400:
		await get_tree().process_frame
		menu = ana.find_child("MenuEkrani", true, false) as MenuEkrani
		if menu == null:
			menu = _sinif_bul(ana, "MenuEkrani") as MenuEkrani
		if menu != null:
			break
	dene(menu != null, "Ana menü açıldı")
	if menu != null:
		await get_tree().process_frame
		dene(not menu._satirlar.is_empty() and menu._satirlar[0].visible, "İlk menü satırı beklemeden görünür")
	var test_yuva := KayitYuvalari.new(TEST_YUVA_KOK)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(TEST_YUVA_KOK))
	dene(test_yuva.yaz(1, {"surum": Oturum.KAYIT_SURUMU, "gun": 1, "nufus": 2, "perde": 1}), "Test yuvası yazılır")
	ana.yuvalar = test_yuva
	ana.yuva_sec(1)
	ana._yeni_oyun_ekrani()
	var secim := ana._ekran as YeniOyunEkrani
	dene(secim != null, "Yeni oyun ekranı açıldı")
	if secim == null:
		_bitir()
		return
	await get_tree().process_frame
	secim._baslat()
	dene(ana._ekran == secim and secim._uyari_etiketi != null and secim._uyari_etiketi.text == "Önce muhafızın geçmişini seç.", "Geçmiş seçilmeden başlatılınca görünür uyarı verilir")
	dene(secim._baslat_dugmesi != null and secim._baslat_dugmesi.text == "Önce muhafızın geçmişini seç", "Geçmiş seçilmeden düğme metni uyarır")
	var ilk_gecmis := secim._gecmis_satir_kutusu.get_child(0) as Button if secim._gecmis_satir_kutusu != null and secim._gecmis_satir_kutusu.get_child_count() > 0 else null
	dene(ilk_gecmis != null, "Geçmiş düğmeleri hazır")
	if ilk_gecmis != null:
		ilk_gecmis.pressed.emit()
	dene(secim._uyari_etiketi.text.is_empty(), "Geçmiş seçilince uyarı temizlenir")
	if secim._tohum != null:
		secim._tohum.text = "1402"
	secim._baslat()
	dene(ana._ekran == secim and secim._onay and secim._baslat_dugmesi.text == "Dolu yuvanın üzerine yaz (Onayla)", "Dolu yuvada ilk tıklamada onay istenir ve düğme metni değişir")
	dene(secim._uyari_etiketi.text.contains("dolu"), "Dolu yuvada ilk tıklamada uyarı metni gösterilir")
	secim._baslat()
	var kadraj: BilgiEkrani = null
	var bitis := Time.get_ticks_msec() + 6000
	while Time.get_ticks_msec() < bitis:
		await get_tree().process_frame
		kadraj = ana._ekran as BilgiEkrani
		if kadraj != null:
			break
	dene(kadraj != null, "Açılış kadrajı geldi")
	if kadraj != null:
		kadraj.secildi.emit(0)
	await get_tree().process_frame
	for _i in 400:
		if ana._ekran is KoyEkrani:
			break
		await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	dene(e != null and e.sahne3b != null, "Yeni oyun köy sahnesi yüklendi")
	if e != null and e.sahne3b != null:
		await get_tree().process_frame
		await get_tree().process_frame
		var kok := e.sahne3b.find_child("topluluk_dekoru", true, false)
		var sayi := kok.get_child_count() if kok != null else -1
		dene(kok != null and kok.has_meta(&"topluluk_dekoru") and sayi == ToplulukDekoru._liste().size(), "Köyde dekorlar duruyor")
	_bitir()

func _sinif_bul(kok: Node, sinif: String) -> Node:
	if kok.get_script() != null and str(kok.get_script().get_global_name()) == sinif:
		return kok
	for c in kok.get_children():
		var b := _sinif_bul(c, sinif)
		if b != null:
			return b
	return null

func _bitir() -> void:
	_test_yuvayi_temizle()
	print("AÇILIŞ MENÜ: GEÇTİ" if hata == 0 else "AÇILIŞ MENÜ: KALDI")
	get_tree().quit(0 if hata == 0 else 1)

func _test_yuvayi_temizle() -> void:
	var yol := ProjectSettings.globalize_path(TEST_YUVA_KOK)
	if not DirAccess.dir_exists_absolute(yol):
		return
	for ad in DirAccess.get_files_at(yol):
		DirAccess.remove_absolute(yol.path_join(ad))
	DirAccess.remove_absolute(yol)

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
