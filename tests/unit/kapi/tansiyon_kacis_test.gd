## ZAR-03: Tansiyon 10'u aşarsa karakter gider birim testi.
## Çalıştırma: godot --headless --path . -s tests/unit/kapi/tansiyon_kacis_test.gd
extends SceneTree

const SORGUSARI = preload("res://src/kapi/sorgu_zari.gd")
const ADAPTOR = preload("res://src/kapi/tansiyon_kacis_adaptoru.gd")

var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error("HATA: %s" % ad)
		print("FAIL: %s" % ad)
	else:
		print("PASS: %s" % ad)

func _initialize() -> void:
	# 1. Ek şart: Eşik sayısı data/ayarlar/denge.json içindedir.
	var denge_dosyasi := FileAccess.open("res://data/ayarlar/denge.json", FileAccess.READ)
	dene(denge_dosyasi != null, "denge.json dosyası mevcut ve okunabilir")
	var denge_json: Variant = JSON.parse_string(denge_dosyasi.get_as_text())
	dene(denge_json is Dictionary and denge_json.has("zar_esigi"), "denge.json zar_esigi içeriyor")
	var zar_esigi_tablosu: Dictionary = denge_json.get("zar_esigi", {})
	dene(zar_esigi_tablosu.has("tansiyon_kacis_esigi"), "zar_esigi.tansiyon_kacis_esigi denge.json içinde var")
	var esik_degeri: int = int(zar_esigi_tablosu.get("tansiyon_kacis_esigi", 0))
	dene(esik_degeri == 10, "denge.json içindeki tansiyon_kacis_esigi 10'dur")

	var kurallar: Resource = load("res://data/chr_runtime/sorgu_kurallari.tres")
	dene(kurallar != null and kurallar.get("tansiyon_kacis_esigi") == 10, "sorgu_kurallari.tres tansiyon_kacis_esigi 10")
	dene(SORGUSARI.kacis_esigi_oku() == 10, "SorguZari.kacis_esigi_oku() 10 döner")
	dene(ADAPTOR.kacis_esigi() == 10, "TansiyonKacisAdaptoru.kacis_esigi() 10 döner")

	# 2. Kabul: Tansiyon 10, başarısız zar ve artış 1 iken karar "kaçtı" olur.
	var k1 := SORGUSARI.kacis_kontrol(10, 1, false, esik_degeri)
	dene(k1["kacti"] == true, "Tansiyon 10 + 1 başarısız zar: karakter kaçar")
	dene(k1["karar_str"] == "kaçtı" and k1["karar"] == &"kacti", "Karar 'kaçtı' olur")
	dene(k1["tansiyon"] == 11, "Yeni tansiyon 11'dir")

	var k1_adp := ADAPTOR.kontrol(10, 1, false, esik_degeri)
	dene(k1_adp["kacti"] == true and k1_adp["karar_str"] == "kaçtı", "Adaptor kontrolü de karar 'kaçtı' döner")

	# 3. Kabul: Tansiyon 10 ve başarılı zarda karakter durur.
	var k2 := SORGUSARI.kacis_kontrol(10, 1, true, esik_degeri)
	dene(k2["kacti"] == false, "Tansiyon 10 ve başarılı zarda karakter kaçmaz, durur")
	dene(k2["karar_str"] == "" and k2["karar"] == &"", "Başarılı zarda karar kaçtı olmaz")
	dene(k2["tansiyon"] == 10, "Başarılı zarda tansiyon değişmez")

	# 4. Uç durum: Tansiyon 10'da artış +0 olan başarısızlık kaçırmaz.
	var k3 := SORGUSARI.kacis_kontrol(10, 0, false, esik_degeri)
	dene(k3["kacti"] == false, "Tansiyon 10 ve artış 0 olan başarısızlık kaçırmaz")

	# 5. Eşik kontrolü: Tansiyon 9 + artış 1 = 10, 10'u aşmadığı için kaçırmaz.
	var k4 := SORGUSARI.kacis_kontrol(9, 1, false, esik_degeri)
	dene(k4["kacti"] == false, "Tansiyon 9 + 1 = 10: 10'u aşmadığı için kaçmaz")

	# 6. Kural 1: Başarısız zar tansiyonu seçenekte yazan kadar artırır; yazılmamışsa +1'dir.
	dene(SORGUSARI.basarisiz_artis({"tansiyon_delta": 3}) == 3, "Seçenekte tansiyon_delta=3 ise artış 3'tür")
	dene(SORGUSARI.basarisiz_artis({}) == 1, "Seçenekte tansiyon_delta yazılmamışsa artış varsayılan +1'dir")
	dene(ADAPTOR.basarisiz_artis({}) == 1, "Adaptör basarisiz_artis varsayılan 1 döner")

	# 7. Ek şart: Kaçış ret_sayisi artırmaz.
	var katalog := Katalog.new()
	if katalog.yukle() == Katalog.Durum.HAZIR:
		var oturum := Oturum.new(katalog, 1234)
		var gelen := Gelen.new()
		gelen.id = &"test_kacan_01"
		gelen.ad_anahtari = "Test Kişi"
		gelen.tehlikeli = false

		var ret_once: int = oturum.yonetim.ret_sayisi
		var akce_once: int = oturum.muhafiz_akce
		var sonuc := SORGUSARI.karar_uygula(oturum, gelen, "kaçtı")
		dene(sonuc["karar"] == "kaçtı", "Sonuç kararı 'kaçtı'dır")
		dene(sonuc["kaldi"] == false, "Kaçan kişi köyde kalmaz (kaldi = false)")
		dene(oturum.yonetim.ret_sayisi == ret_once, "Ek şart: kaçış ret_sayisi artırmaz (%d == %d)" % [oturum.yonetim.ret_sayisi, ret_once])
		dene(oturum.muhafiz_akce == akce_once, "DEN-19: kaçışta muhafiz_akce değişmez (%d == %d)" % [oturum.muhafiz_akce, akce_once])

		# 8. Kural 4: Tehlikeli karakter kaçarsa sonraki tehdit, duran tehdit sayacına (asayis_riski) yazar.
		var tehlikeli_gelen := Gelen.new()
		tehlikeli_gelen.id = &"test_kacan_casus"
		tehlikeli_gelen.ad_anahtari = "Tehlikeli Kişi"
		tehlikeli_gelen.tehlikeli = true

		var asayis_once: int = oturum.yonetim.asayis_riski
		var sonuc_tehlikeli := ADAPTOR.uygula(oturum, tehlikeli_gelen, "kaçtı")
		dene(sonuc_tehlikeli["karar"] == "kaçtı", "Tehlikeli kişi kaçış kararı 'kaçtı'")
		dene(oturum.yonetim.ret_sayisi == ret_once, "Tehlikeli kişi kaçışı da ret_sayisi artırmaz")
		dene(oturum.yonetim.asayis_riski > asayis_once, "Tehlikeli kişi kaçınca duran tehdit sayacı (asayis_riski) arttı (%d > %d)" % [oturum.yonetim.asayis_riski, asayis_once])
	else:
		push_error("Katalog yüklenemedi")
		hata += 1

	print("TANSIYON KACIS TEST: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)
