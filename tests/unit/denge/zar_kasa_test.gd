## DEN-20 & DEN-21: Zar türleri ve değiştirici listesi ekonomi üretmez birim testi.
## DEN-20: d6 ve d12 aynı ekonomik kapıyı kullanır (aynı karar, iki zar türü, kasa farkı 0).
## DEN-21: ZAR-04 değiştiricisi yalnız gereken sayıyı değiştirir. Akçe satırı yoktur.
##          Test: asker yanındayken kasa aynı kararda aynıdır.
## Çalıştırma: godot --headless --path . -s tests/unit/denge/zar_kasa_test.gd
extends SceneTree

const ZAR_DEGISTIRICI = preload("res://src/kapi/zar_degistiricileri.gd")
const SORGUSARI = preload("res://src/kapi/sorgu_zari.gd")

var _hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		_hata += 1
		push_error("HATA: %s" % ad)
		print("FAIL: %s" % ad)
	else:
		print("PASS: %s" % ad)

func _initialize() -> void:
	# 1. DEN-21: Tabloda akçe / kasa / para alanı yoktur
	var tablo_dosyasi := FileAccess.open("res://data/zar_degistiricileri.json", FileAccess.READ)
	dene(tablo_dosyasi != null, "zar_degistiricileri.json dosyası mevcut")
	var metin := tablo_dosyasi.get_as_text().to_lower()
	dene(not "akce" in metin and not "kasa" in metin and not "para" in metin, "Tabloda akçe/kasa/para satırı yoktur")

	# 2. DEN-21: ZAR-04 hesaplamasında dönen satırlarda ekonomi/akçe alanı yoktur
	for y in [&"ikna", &"blof", &"gozdagi", &"gonul_alma"]:
		var sonuc := ZAR_DEGISTIRICI.hesapla(y, {
			"terazi": "adil",
			"kanit": true,
			"asker": true,
			"yorgunluk": true,
			"itibar": 1
		})
		dene(sonuc["gecerli"], "Yaklaşım %s geçerli" % y)
		for s in sonuc["satirlar"]:
			dene(not s.has("akce") and not s.has("kasa") and not s.has("para"), "Satırda akçe/kasa anahtarı yoktur (%s)" % s.get("tur", ""))

	# 3. DEN-21: Asker yanındayken kasa aynı kararda aynıdır
	# Asker varlığı (asker=true vs asker=false) yalnız gözdağı zar zorluğunu değiştirir,
	# verilen kararın (kabul/ret/rüşvet/harç) kasaya etkisini değiştirmez.
	var k := Katalog.new()
	if k.yukle() == Katalog.Durum.HAZIR:
		# Test: Oturumda asker yanındayken ve yokken aynı kararın kasa etkisi
		var o1 := Oturum.new(k, 101)
		var o2 := Oturum.new(k, 101)

		# Oturum 1: Asker yok
		var g1 := _yeni_gelen(5)
		var baglam_askersiz := {"asker": false, "terazi": "adil"}
		var deg_askersiz := ZAR_DEGISTIRICI.hesapla(&"gozdagi", baglam_askersiz)
		dene(deg_askersiz["toplam"] == 0, "Askersiz gözdağı değiştirici toplamı 0")
		var s1 := o1.karar_ver(g1, &"kabul")

		# Oturum 2: Asker var
		var g2 := _yeni_gelen(5)
		var baglam_askerli := {"asker": true, "terazi": "adil"}
		var deg_askerli := ZAR_DEGISTIRICI.hesapla(&"gozdagi", baglam_askerli)
		dene(deg_askerli["toplam"] == -1, "Askerli gözdağı değiştirici toplamı -1 (zorluğu düşürür)")
		var s2 := o2.karar_ver(g2, &"kabul")

		# Kasa karşılaştırması: asker yanındayken kasa aynı kararda aynıdır
		dene(o1.muhafiz_akce == o2.muhafiz_akce, "Askerli ve askersiz kabulde muhafız akçesi aynıdır (%d == %d)" % [o1.muhafiz_akce, o2.muhafiz_akce])
		dene(o1.akce == o2.akce, "Askerli ve askersiz kabulde köy akçesi aynıdır (%d == %d)" % [o1.akce, o2.akce])

		# Ret kararı için de kasa farkı 0
		var o3 := Oturum.new(k, 202)
		var o4 := Oturum.new(k, 202)
		o3.karar_ver(_yeni_gelen(5), &"ret")
		o4.karar_ver(_yeni_gelen(5), &"ret")
		dene(o3.muhafiz_akce == o4.muhafiz_akce and o3.akce == o4.akce, "Ret kararında asker varlığı kasa farkı üretmez (kasa farkı 0)")

		# Rüşvet kararı için de kasa farkı 0
		var o5 := Oturum.new(k, 303)
		var o6 := Oturum.new(k, 303)
		o5.karar_ver(_yeni_gelen(5), &"rusvet")
		o6.karar_ver(_yeni_gelen(5), &"rusvet")
		dene(o5.muhafiz_akce == o6.muhafiz_akce, "Rüşvet kararında da muhafız akçesi aynıdır (%d == %d)" % [o5.muhafiz_akce, o6.muhafiz_akce])

		# 4. DEN-20: d6 ve d12 aynı ekonomik kapıyı kullanır
		# Yüzün türü yalnız zorluğu değiştirir, kasaya ayrı çarpan yazmaz.
		# İki ayrı oturumda aynı karar, biri d6 diğeri d12 zar türüyle sorgulansa dahi kasa farkı 0'dır.
		var rng := RandomNumberGenerator.new()
		rng.seed = 777
		var kurallar: Resource = load("res://data/chr_runtime/sorgu_kurallari.tres")
		var zar_d6 := SORGUSARI.sonuc(rng, &"d6", 2, 2, 0, kurallar)
		var zar_d12 := SORGUSARI.sonuc(rng, &"d12", 2, 2, 0, kurallar)
		dene(zar_d6["tur"] == &"d6" and zar_d12["tur"] == &"d12", "İki farklı zar türü atıldı")
		dene(not zar_d6.has("akce") and not zar_d12.has("akce"), "Zar sonucunda akçe çarpanı yoktur")

		var o_d6 := Oturum.new(k, 404)
		var o_d12 := Oturum.new(k, 404)
		o_d6.karar_ver(_yeni_gelen(5), &"kabul")
		o_d12.karar_ver(_yeni_gelen(5), &"kabul")
		dene(o_d6.muhafiz_akce == o_d12.muhafiz_akce and o_d6.akce == o_d12.akce, "DEN-20: aynı karar, iki zar türü, kasa farkı 0")
	else:
		push_error("Katalog yüklenemedi")
		_hata += 1

	print("ZAR KASA TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(_hata)


func _yeni_gelen(stat: int) -> Gelen:
	var g := Gelen.new()
	g.ad_anahtari = "deneme_kisi"
	g.sinif = &"ciftci"
	g.stat = stat
	g.secenekler = PackedStringArray(["kabul", "harc", "ret", "rusvet", "kisla"])
	return g
