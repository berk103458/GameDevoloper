## Ana menü ve yeni oyun köy sahnesi yüklenir. SCRIPT ERROR / eksik kaynak = çıkış 1.
extends Node

var hata := 0

func _ready() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	get_tree().create_timer(90.0).timeout.connect(func() -> void: get_tree().quit(1))
	for ad in Dunya3B.TOPLULUK_YER:
		dene(ResourceLoader.exists(Dunya3B.TOPLULUK_YER[ad]), "Kaynak var: %s" % ad)
	var pak := load("res://src/arayuz/ana.tscn") as PackedScene
	dene(pak != null, "Ana menü sahnesi yüklenir")
	if pak == null:
		_bitir()
		return
	var ana := pak.instantiate() as Ana
	add_child(ana)
	var menu: Node = null
	for _i in 400:
		await get_tree().process_frame
		menu = ana.find_child("MenuEkrani", true, false)
		if menu == null:
			menu = _sinif_bul(ana, "MenuEkrani")
		if menu != null:
			break
	dene(menu != null, "Ana menü açıldı")
	ana._yeni_oyun_ekrani()
	var secim := ana._ekran as YeniOyunEkrani
	dene(secim != null, "Yeni oyun ekranı açıldı")
	if secim == null:
		_bitir()
		return
	secim.baslatildi.emit(1402, "eski_levent")
	await get_tree().process_frame
	var kadraj := ana._ekran as BilgiEkrani
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
	print("AÇILIŞ MENÜ: GEÇTİ" if hata == 0 else "AÇILIŞ MENÜ: KALDI")
	get_tree().quit(0 if hata == 0 else 1)

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
