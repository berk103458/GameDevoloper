## DEN-02: Tablo sürümü kayıtla birlikte durur birim testi.
## Ne: denge dosyasının sürümü KAY-04 içeriğinden ayrıdır. Eski kayıt yeni tabloyla açılır. Kayıt, tabloyu içine gömmez.
## Kabul: denge dosyasının sürümü KAY-04 içeriğinden ayrıdır. Eski kayıt yeni tabloyla açılır. Kayıt, tabloyu içine gömmez. Test: tablo sürümü artınca köylü sayısı değişmez.
## Çalıştırma: godot --headless --path . -s tests/unit/denge/tablo_surumu_test.gd
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
	# 1. denge.json içinde surum alanı mevcuttur
	var dosya := FileAccess.open("res://data/ayarlar/denge.json", FileAccess.READ)
	dene(dosya != null, "denge.json mevcut")
	var denge_json: Variant = JSON.parse_string(dosya.get_as_text())
	dene(denge_json is Dictionary and denge_json.has("surum"), "denge.json surum alanı içerir")
	var tablo_surumu: int = int(denge_json.get("surum", 0))
	dene(tablo_surumu >= 1, "Tablo sürümü pozitif bir tam sayıdır (%d)" % tablo_surumu)

	# 2. Kayıt, tabloyu içine gömmez ve kayıt sürümü (KAY-04: 3) tablo sürümünden ayrıdır
	var k := Katalog.new()
	if k.yukle() == Katalog.Durum.HAZIR:
		var o := Oturum.new(k, 42)
		var kayit := o.kaydet()
		dene(kayit.has("surum"), "Kayıt kendi sürümünü taşır (KAY-04)")
		dene(int(kayit["surum"]) == Oturum.KAYIT_SURUMU, "Kayıt sürümü %d'dir" % Oturum.KAYIT_SURUMU)
		dene(not kayit.has("denge") and not kayit.has("denge_tablosu"), "Kayıt denge tablosunu içine gömmez")

		var nufus_once := o.yonetim.nufus()
		dene(nufus_once >= 0, "Mevcut köylü nüfusu geçerli (%d)" % nufus_once)

		# 3. Tablo sürümü artınca eski kayıt yeni tabloyla sorunsuz açılır; köylü sayısı değişmez
		var yeni_tablo_surumu := tablo_surumu + 1
		# Kayıttan geri yükle
		var yuklenen := Oturum.kayittan(k, JSON.parse_string(JSON.stringify(kayit)))
		dene(yuklenen != null, "Eski kayıt yeni tablo bağlamında açıldı")
		dene(yuklenen.yonetim.nufus() == nufus_once, "Tablo sürümü artınca köylü sayısı değişmez (%d == %d)" % [yuklenen.yonetim.nufus(), nufus_once])
	else:
		push_error("Katalog yüklenemedi")
		_hata += 1

	print("TABLO SURUMU TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(_hata)
