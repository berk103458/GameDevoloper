## SRM-14: duraklat → "Menüye dön" mevcut kaydı silmez; yeni onay penceresi açılmaz.
## Gerçek Ana akışı; oyuncunun gerçek kaydına dokunulmaz (Ana._ready sonrası test yolu).
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
	ana.kayit = GuvenliKayit.new("user://srm14_duraklat_test.json")
	ana.kayit.yaz({"surum": 1, "isaret": "srm14"})
	_kontrol(ana.kayit.var_mi(), "Test kaydı yazıldı")
	ana._duraklat()
	await get_tree().process_frame
	var ust: Node = ana._ust
	_kontrol(ust != null and ust.has_signal("secildi"), "Duraklat penceresi açıldı")
	var usul_dugmesi: Button = null
	for dugme in ust.find_children("*", "Button", true, false):
		if dugme.text == tr("arayuz.duraklat.kapi_usulu"): usul_dugmesi = dugme
	_kontrol(usul_dugmesi != null, "OGR-35 duraklat menüsünde Kapı usulü var")
	if usul_dugmesi != null:
		usul_dugmesi.pressed.emit()
		await get_tree().process_frame
		var sayfa: Control = ana._ust
		var kaydir := sayfa.find_child("UsulKaydirma", true, false) as ScrollContainer
		var anahtarlar := {}
		if kaydir != null:
			for satir in kaydir.find_children("*", "Label", true, false):
				var anahtar := String(satir.get_meta(&"usul_anahtari", ""))
				if not anahtar.is_empty() and satir.text == tr(anahtar) and satir.text != anahtar:
					anahtarlar[anahtar] = true
		_kontrol(anahtarlar.size() == 25, "OGR-35 tek kaydırmada 25 çevrilmiş yardım satırı")
		var geri := InputEventAction.new()
		geri.action = &"geri"
		geri.pressed = true
		sayfa._unhandled_input(geri)
		await get_tree().process_frame
		ust = ana._ust
		_kontrol(ust != null and ust.has_signal("secildi"), "OGR-35 Geri duraklat menüsüne döner")
	if ust != null and ust.has_signal("secildi"):
		ust.secildi.emit(2)  # 2: Menüye dön
	await get_tree().create_timer(0.3).timeout
	_kontrol(ana._ekran is MenuEkrani, "Duraklattan menüye dönüldü")
	_kontrol(ana._ust == null, "Ek onay penceresi açılmadı")
	_kontrol(ana.kayit.var_mi(), "Menüye dönüş kaydı silmedi")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("DURAKLAT MENÜ KAYIT: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	await Ses.cik(hata)


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
