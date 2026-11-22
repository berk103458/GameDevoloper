## Çalıştırma: godot --headless --path . -s tests/unit/arayuz/ulak_parsomen_animasyonu_test.gd
extends SceneTree

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _kontrol(v: bool, ad: String) -> void:
	if not v:
		push_error(ad)
		hata += 1

func _calistir() -> void:
	_kontrol(ResourceLoader.exists(UlakParsomenAnimasyonu.ULAK_YOL), "ulak asker dokusu duruyor")
	var kareler := UlakParsomenAnimasyonu.kareleri()
	_kontrol(kareler.size() == UlakParsomenAnimasyonu.KARE_SAYISI, "dokuz parşömen karesi yüklenir")
	var n := UlakParsomenAnimasyonu.olustur()
	_kontrol(n != null and n._kareler.size() == UlakParsomenAnimasyonu.KARE_SAYISI, "olustur kare dizisini kurar")
	n.queue_free()
	quit(1 if hata else 0)
