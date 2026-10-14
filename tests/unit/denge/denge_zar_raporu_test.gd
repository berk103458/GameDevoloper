## DEN-22: Yüz başarısız zarın gece raporu tek satırdır birim testi.
## Ne: rapor, o gecenin başarısız zar sayısını yazar. Her zar için ayrı ekonomik satır açmaz.
## Kabul: rapor, o gecenin başarısız zar sayısını yazar. Her zar için ayrı ekonomik satır açmaz.
## Test: 3 başarısızlık, raporda bir sayı. 100 başarısızlık, yine tek sayı ve tek satır.
## Çalıştırma: godot --headless --path . -s tests/unit/denge/denge_zar_raporu_test.gd
extends SceneTree

const DENGE_OLCUMU = preload("res://src/sistemler/denge_olcumu.gd")

var _hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		_hata += 1
		push_error("HATA: %s" % ad)
		print("FAIL: %s" % ad)
	else:
		print("PASS: %s" % ad)

func _initialize() -> void:
	var dummy_gece_raporu := {
		"gece": 5,
		"tuketim": {"gida": 20},
		"ac_sayisi": 0,
		"bilanco": {"kamu": {"maas": 15}}
	}

	# 1. Test senaryosu 1: 3 başarısız zar
	var baglam_3 := {
		"basarisiz_zar_sayisi": 3
	}
	var rapor_3 := DENGE_OLCUMU.olustur(null, dummy_gece_raporu, baglam_3)

	dene(rapor_3.has("basarisiz_zar_sayisi"), "Raporda basarisiz_zar_sayisi anahtarı var")
	dene(rapor_3["basarisiz_zar_sayisi"] == 3, "3 başarısızlık durumunda değer 3")
	dene(DENGE_OLCUMU.zar_rapor_satir_sayisi(rapor_3) == 1, "3 başarısızlık durumunda zarla ilgili tek bir satır var")

	# 2. Test senaryosu 2: 100 başarısız zar
	var baglam_100 := {
		"basarisiz_zar_sayisi": 100
	}
	var rapor_100 := DENGE_OLCUMU.olustur(null, dummy_gece_raporu, baglam_100)

	dene(rapor_100["basarisiz_zar_sayisi"] == 100, "100 başarısızlık durumunda değer 100")
	dene(DENGE_OLCUMU.zar_rapor_satir_sayisi(rapor_100) == 1, "100 başarısızlık durumunda zarla ilgili yine tek bir satır var")

	# 3. Her zar için ayrı ekonomik satır veya ayrı anahtar açılmamıştır
	dene(not rapor_100.has("zar_1") and not rapor_100.has("zar_100"), "Ayrı zar satırları açılmaz")
	dene(not rapor_100.has("zar_masrafi") and not rapor_100.has("zar_bedeli"), "Zar için ayrı ekonomik maliyet/akçe satırı açılmaz")

	# 4. Ekonomik tüketim (gıda, nöbet maaşı) zar sayısı 3 veya 100 olunca değişmez
	dene(rapor_3["gida_tuketimi"] == rapor_100["gida_tuketimi"], "Gıda tüketimi zar sayısından bağımsızdır")
	dene(rapor_3["nobet_maasi"] == rapor_100["nobet_maasi"], "Nöbet maaşı zar sayısından bağımsızdır")

	# 5. Toplam anahtar sayısı iki raporda da eşittir (satır sayısı artmaz)
	dene(rapor_3.keys().size() == rapor_100.keys().size(), "100 başarısızlıkta rapor satır sayısı artmaz, tek satırdır")

	print("DENGE ZAR RAPORU TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(_hata)
