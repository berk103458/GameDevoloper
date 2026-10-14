## DEN-06: Rapor oyuncuya açılmaz birim testi.
## Ne: ölçüm geliştirme günlüğündedir. Kapı ve köy HUD'unda denge sayısı görünmez.
## Kabul: ölçüm geliştirme günlüğündedir. Kapı ve köy HUD'unda denge sayısı görünmez.
## Test: oyuncu arayüzünde "denge" anahtarı 0.
## Çalıştırma: godot --headless --path . -s tests/unit/denge/denge_hud_test.gd
extends SceneTree

const DENGE_OLCUMU = preload("res://src/sistemler/denge_olcumu.gd")
const HUD_SCRIPT = preload("res://src/arayuz/hud.gd")

var _hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		_hata += 1
		push_error("HATA: %s" % ad)
		print("FAIL: %s" % ad)
	else:
		print("PASS: %s" % ad)

func _initialize() -> void:
	# 1. Denge ölçümü oyuncuya açık değildir
	dene(not DENGE_OLCUMU.oyuncuya_acik_mi(), "Denge ölçümü oyuncuya kapalıdır")

	# 2. Üretilen raporda oyuncuya_gorunur bayrağı false'tur
	var olcum := DENGE_OLCUMU.olustur(null, {})
	dene(olcum.has("oyuncuya_gorunur") and olcum["oyuncuya_gorunur"] == false, "Ölçüm raporu oyuncuya_gorunur: false taşır")

	# 3. Köy ve kapı HUD üst kaynak şeridinde (Hud.STOKLAR) 'denge' anahtarı sayısı 0'dır
	var stok_denge_sayisi: int = DENGE_OLCUMU.oyuncu_arayuz_denge_anahtar_sayisi(HUD_SCRIPT.STOKLAR)
	dene(stok_denge_sayisi == 0, "Hud.STOKLAR listesinde 'denge' anahtarı 0")

	# 4. Hud sınıfının dışa açık stok listesinde 'denge' yoktur
	dene(not HUD_SCRIPT.STOKLAR.has("denge"), "Hud STOKLAR içinde 'denge' kaydı yok")

	# 5. Oyuncu arayüzü görünüm sözlüğünde 'denge' anahtarı sayısı 0'dır
	var oyuncu_arayuz_verisi := {
		"akce": 100,
		"gida": 50,
		"odun": 20,
		"tas": 10,
		"huzur": 70,
		"adalet": 60,
		"asayis": 55,
		"gun": 1
	}
	var arayuz_denge_sayisi: int = DENGE_OLCUMU.oyuncu_arayuz_denge_anahtar_sayisi(oyuncu_arayuz_verisi)
	dene(arayuz_denge_sayisi == 0, "Oyuncu arayüz verisinde 'denge' anahtarı sayısı 0'dır")

	print("DENGE HUD TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(_hata)
