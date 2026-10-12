## SRM-13: kayıt dosyası yokken menüdeki "Devam" düğmesi pasiftir; kayıt varken etkindir.
## Gerçek Ana menüsü; kullanıcının gerçek kaydı yerine test yolu kullanılır (KayitDeposu yolu).
extends Node
var hata := 0


func _ready() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := Ana.new()
	add_child(ana)
	while ana._ekran == null or not ana._ekran is MenuEkrani:
		await get_tree().process_frame
	# Oyuncunun gerçek kaydına dokunulmaz: Ana._ready'den sonra test yolu atanır, menü yeniden kurulur.
	ana.kayit = GuvenliKayit.new("user://srm13_devam_test.json")
	ana.kayit.sil()
	ana.ana_menu()
	await get_tree().create_timer(0.5).timeout
	var devam := _dugme(ana._ekran, tr("arayuz.menu.devam"))
	_kontrol(devam != null, "Menüde Devam düğmesi var")
	_kontrol(devam != null and devam.disabled, "Kayıt yokken Devam pasif")
	_kontrol(ana._ekran.pasifler == [1], "Kayıt yokken pasifler içinde 1")
	# Kayıt varken menü yeniden kurulunca Devam etkin olur.
	ana.kayit.yaz({"surum": 1})
	ana.ana_menu()
	await get_tree().create_timer(0.5).timeout
	devam = _dugme(ana._ekran, tr("arayuz.menu.devam"))
	_kontrol(devam != null and not devam.disabled, "Kayıt varken Devam etkin")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("DEVAM PASİF: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	await Ses.cik(hata)


func _dugme(kok: Node, metin: String) -> Button:
	for b in kok.find_children("*", "Button", true, false):
		if (b as Button).text == metin:
			return b
	return null


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
