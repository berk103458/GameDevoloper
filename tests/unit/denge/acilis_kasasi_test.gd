## DEN-14: Açılışta akçe iki kasada da tablodadır birim testi.
## Ne: köy akçesi ve muhafız akçesi ayrı satırdır. Göç onları birbirine katmaz (KAY-45).
## Kabul: köy akçesi ve muhafız akçesi ayrı satırdır. Göç onları birbirine katmaz (KAY-45).
## Test: iki satır, toplam kodda yazılmaz.
## Çalıştırma: godot --headless --path . -s tests/unit/denge/acilis_kasasi_test.gd
extends SceneTree

var _hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		_hata += 1
		push_error("HATA: %s" % ad)
		print("FAIL: %s" % ad)
	else:
		print("PASS: %s" % ad)

func _initialize() -> void:
	# 1. denge.json açılır ve okunur
	var dosya := FileAccess.open("res://data/ayarlar/denge.json", FileAccess.READ)
	dene(dosya != null, "denge.json açıldı")
	var denge_json: Variant = JSON.parse_string(dosya.get_as_text())
	dene(denge_json is Dictionary, "denge.json bir sözlüktür")

	# 2. acilis_kasasi alanı mevcuttur
	dene(denge_json.has("acilis_kasasi"), "denge.json içinde acilis_kasasi var")
	var kasalar: Dictionary = denge_json.get("acilis_kasasi", {})

	# 3. İki kasa ayrı satırdır
	dene(kasalar.has("koy_akce"), "acilis_kasasi içinde koy_akce ayrı satırdır")
	dene(kasalar.has("muhafiz_akce"), "acilis_kasasi içinde muhafiz_akce ayrı satırdır")

	# 4. Toplam alanı ne sözlükte ne de ayrı bir anahtarda yer almaz
	dene(not kasalar.has("toplam") and not kasalar.has("toplam_akce"), "acilis_kasasi içinde toplam alanı yoktur (iki ayrı satır)")
	dene(not denge_json.has("toplam_akce") and not denge_json.has("acilis_toplam_akce"), "denge.json kökünde toplam akçe alanı yoktur")

	# 5. Köy akçesi ve muhafız akçesi değerleri geçerli başlangıç sayılarıdır
	var koy_akce: int = int(kasalar.get("koy_akce", -1))
	var muhafiz_akce: int = int(kasalar.get("muhafiz_akce", -1))
	dene(koy_akce >= 0, "koy_akce pozitif veya sıfırdır")
	dene(muhafiz_akce >= 0, "muhafiz_akce pozitif veya sıfırdır")

	print("ACILIS KASASI TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(_hata)
