## Gerçek Ana menü/kapı geçişi; yeni_oyun çağırmaz, kullanıcı kayıtlarını değiştirmez.
extends Node
var hata := 0
func _ready() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := Ana.new()
	add_child(ana)
	var baslangic := Time.get_ticks_msec()
	while ana._ekran == null or _hazirlaniyor(ana):
		await get_tree().process_frame
	_kontrol(ana._ekran is MenuEkrani, "Gerçek menü threaded batch sonrası kurulur")
	_kontrol(not _hazirlaniyor(ana), "Yükleme bitince panel sayısı sıfır")
	await get_tree().create_timer(0.5).timeout # Mevcut menü satırı belirme animasyonu.
	var ayar_dugmesi: Button
	for b in ana._ekran.find_children("*", "Button", true, false):
		if b.text == tr("arayuz.menu.ayarlar"):
			ayar_dugmesi = b
	_kontrol(ayar_dugmesi != null and ayar_dugmesi.is_visible_in_tree(), "Gerçek menü ayar satırı hazır")
	if ayar_dugmesi != null:
		_fare_tik(ayar_dugmesi.get_global_rect().get_center())
		await get_tree().process_frame
		_kontrol(ana._ekran is AyarlarEkrani, "Panelden sonraki ilk gerçek tıklama menüye ulaşır")
		# Ayar değiştirme/kapatma çağrısı yazmaz; doğrudan menüye dönülür.
		ana.ana_menu()
		await get_tree().process_frame
	var admin: AdminHud = ana.find_children("*", "CanvasLayer", true, false).filter(func(n: Node) -> bool: return n is AdminHud)[0]
	print("MENÜ HAZIR ms: ", Time.get_ticks_msec() - baslangic)
	await _foto("bug01_menu")
	ana.oturum = Oturum.new(ana.katalog, 84)
	var giris_sayisi := {"adet": 0}
	ana.child_entered_tree.connect(func(n: Node) -> void:
		if n is KapiEkrani: giris_sayisi.adet += 1)
	# Önceki oyunun kaydı okunmuş olabilir; bu test kayıt API'sine hiç yazmaz.
	ana._kapiya_git()
	_kontrol(ana._kapi_yukleniyor, "Kapı hazırlığı boyunca tekrar giriş kilitli")
	ana._kapiya_git()
	while ana._kapi_yukleniyor or ana._kapi == null:
		await get_tree().process_frame
	while ana._kapi.sahne._kuyruktakiler.is_empty() and ana._kapi.sahne._gelen == null:
		await get_tree().process_frame
	_kontrol(ana._ekran == ana._kapi and not ana._kapi._kuyruk.is_empty(), "Kuyruk modeli hazırlanınca gerçek kapı oyunu başlar")
	await get_tree().process_frame
	while _hazirlaniyor(ana):
		await get_tree().process_frame
	_kontrol(giris_sayisi.adet == 1 and ana.get_children().filter(func(n: Node) -> bool: return n is KapiEkrani).size() == 1, "İki eşzamanlı çağrı tek gerçek kapı ekranı kurar")
	_kontrol(not ana._kapi_yukleniyor, "Panel bitişinde kapı yükleme kilidi false")
	_kontrol(is_instance_valid(admin) and admin.get_parent() == ana, "Global konsol menü→kapı geçişinde korunur")
	print("KAPI HAZIR ms: ", Time.get_ticks_msec() - baslangic)
	await get_tree().create_timer(0.5).timeout
	await _foto("bug01_kapi")
	admin.ac(true)
	admin._komut("durum")
	_kontrol(admin.durum.text.contains("Köy akçesi") and not get_tree().paused, "Gerçek kapı oturumu konsolda okunur; oyun durmaz")
	await _foto("adm01_konsol")
	ana.free()
	await get_tree().process_frame
	await get_tree().root.get_node("Ses").sustur()
	print("GİRİŞ YÜKLEME: GEÇTİ" if hata == 0 else "GİRİŞ YÜKLEME: KALDI")
	await get_tree().root.get_node("Ses").cik(hata)

func _fare_tik(p: Vector2) -> void:
	var nokta := get_viewport().get_final_transform() * p
	var hareket := InputEventMouseMotion.new()
	hareket.position = nokta
	hareket.global_position = nokta
	hareket.window_id = get_window().get_window_id()
	Input.parse_input_event(hareket)
	for basili in [true, false]:
		var e := InputEventMouseButton.new()
		e.position = nokta
		e.global_position = nokta
		e.button_index = MOUSE_BUTTON_LEFT
		e.pressed = basili
		e.window_id = get_window().get_window_id()
		Input.parse_input_event(e)

func _hazirlaniyor(ana: Ana) -> bool:
	for n in ana.find_children("*", "CanvasLayer", true, false):
		if n is VarlikYuklemePaneli:
			return true
	return false

func _foto(ad: String) -> void:
	var dizin := OS.get_environment("GIRIS_TEST_CIKTI")
	if dizin.is_empty() or DisplayServer.get_name() == "headless":
		return
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(dizin.path_join(ad + ".png"))

func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
