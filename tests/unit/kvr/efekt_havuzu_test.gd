extends SceneTree
var hata := 0
func _initialize() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	var ses := root.get_node("Ses")
	ses.dongu_baslat()
	var muzik: AudioStream = ses._muzik.stream
	var ortam: AudioStream = ses._ortam.stream
	var adet := ses.get_child_count()
	for tur in 8:
		for i in 9:
			_kontrol(ses.oynat(&"sfx_onay"), "Havuzdan efekt çalınır")
		ses.efektleri_temizle()
		for o in ses._efektler:
			_kontrol(not o.playing and o.stream == null, "Eski sahnenin çalan sesi ve referansı kalmaz")
		_kontrol(ses._onbellek.is_empty() and ses._sira == 0, "Cache ve havuz sırası temizlenir")
		_kontrol(ses.get_child_count() == adet, "Geçişler yeni oynatıcı yaratmaz")
		_kontrol(ses._muzik.stream == muzik and ses._ortam.stream == ortam and ses._muzik.playing and ses._ortam.playing, "Arka plan döngüleri korunur")
	var o: AudioStreamPlayer = ses._efektler[0]
	o.stream = muzik
	o.finished.emit()
	_kontrol(o.stream == null, "Bitmiş efektin stream referansı bırakılır")
	ses.oynat(&"sfx_onay")
	var yeni: AudioStream = o.stream
	o.finished.emit()
	_kontrol(o.stream == yeni, "Yeniden kullanılan oynatıcının çalan yeni sesi kesilmez")
	await ses.sustur()
	print("EFEKT HAVUZU: GEÇTİ" if hata == 0 else "EFEKT HAVUZU: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
