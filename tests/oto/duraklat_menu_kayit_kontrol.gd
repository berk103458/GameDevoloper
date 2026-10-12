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
