## ZAR-04: Yaklaşım türleri ve değiştiriciler birim testi.
## Çalıştırma: godot --headless --path . -s tests/unit/kapi/zar_degistirici_test.gd
extends SceneTree

const ZAR_DEGISTIRICI = preload("res://src/kapi/zar_degistiricileri.gd")

var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error("HATA: %s" % ad)
		print("FAIL: %s" % ad)
	else:
		print("PASS: %s" % ad)

func _initialize() -> void:
	# 1. data/zar_degistiricileri.json tablosu var ve geçerli
	var dosya := FileAccess.open("res://data/zar_degistiricileri.json", FileAccess.READ)
	dene(dosya != null, "zar_degistiricileri.json mevcut")
	var j: Variant = JSON.parse_string(dosya.get_as_text())
	dene(j is Dictionary, "zar_degistiricileri.json geçerli bir nesne")
	var tablo_hatalari := ZAR_DEGISTIRICI.tablo_dogrula(j as Dictionary)
	dene(tablo_hatalari.is_empty(), "Gerçek tablo doğrulamadan 0 hatayla geçti")

	# 2. Dört yaklaşım geçerli, beşinci tür reddedilir
	dene(ZAR_DEGISTIRICI.gecerli_yaklasim("ikna"), "ikna geçerli")
	dene(ZAR_DEGISTIRICI.gecerli_yaklasim("blof"), "blöf geçerli")
	dene(ZAR_DEGISTIRICI.gecerli_yaklasim("gozdagi"), "gözdağı geçerli")
	dene(ZAR_DEGISTIRICI.gecerli_yaklasim("gonul_alma"), "gönül alma geçerli")
	dene(not ZAR_DEGISTIRICI.gecerli_yaklasim("baskı"), "beşinci tür 'baskı' reddedilir")
	dene(not ZAR_DEGISTIRICI.gecerli_yaklasim("besinci"), "beşinci tür reddedilir")

	# 3. Ek şart: kalp veya romans anahtarı 1 hata verir
	var r_kalp := ZAR_DEGISTIRICI.hesapla("kalp")
	dene(not r_kalp["gecerli"] and not r_kalp["hata"].is_empty(), "kalp yaklaşımı hata verir")
	var r_romans := ZAR_DEGISTIRICI.hesapla("romans")
	dene(not r_romans["gecerli"] and not r_romans["hata"].is_empty(), "romans yaklaşımı hata verir")
	var bozuk_tablo := {"yaklasimlar": ["ikna", "romans"]}
	var bozuk_hatalar := ZAR_DEGISTIRICI.tablo_dogrula(bozuk_tablo)
	dene(bozuk_hatalar.size() >= 1, "Tabloda romans anahtarı hata verir")

	# 4. Kabul: Adil terazi ve bulunan kanıt ikna eşiğini 2 düşürür
	var r_ikna := ZAR_DEGISTIRICI.hesapla("ikna", {"terazi": "adil", "kanit": true})
	dene(r_ikna["gecerli"] and r_ikna["toplam"] == -2, "Adil terazi ve bulunan kanıt ikna eşiğini 2 düşürür (-2)")
	dene(r_ikna["satirlar"].size() == 2, "İki ayrı satır görünür")

	# 5. Kabul: Asker iknaya yazmaz
	var r_ikna_asker := ZAR_DEGISTIRICI.hesapla("ikna", {"asker": true})
	dene(r_ikna_asker["toplam"] == 0 and r_ikna_asker["satirlar"].is_empty(), "Asker iknaya yazmaz (toplam 0, satır yok)")

	# 6. Kabul: Yoz gözdağı 1 düşürür
	var r_yoz := ZAR_DEGISTIRICI.hesapla("gozdagi", {"terazi": "yoz"})
	dene(r_yoz["toplam"] == -1, "Yoz terazi gözdağını 1 düşürür (-1)")

	# 7. Uç durum: Asker yokken asker satırı listede hiç yazılmaz
	var r_gozdagi_askersiz := ZAR_DEGISTIRICI.hesapla("gozdagi", {"asker": false, "terazi": "yoz"})
	var asker_satiri_var := false
	for s in r_gozdagi_askersiz["satirlar"]:
		if s["tur"] == "asker": asker_satiri_var = true
	dene(not asker_satiri_var, "Asker yokken asker satırı listede hiç yazılmaz")

	# 8. Uç durum: İki kanıt ikinci -1 vermez; "bulundu mu" sayılır
	var r_cift_kanit := ZAR_DEGISTIRICI.hesapla("ikna", {"kanit_sayisi": 2})
	dene(r_cift_kanit["toplam"] == -1, "İki kanıt tek -1 verir, ikinci -1 vermez")

	# 9. Kabul: Toplam eksi 4 hesaplanırsa eksi 3'e kesilir ve listede kesildiği yazar
	var r_asiri := ZAR_DEGISTIRICI.hesapla("gozdagi", {
		"terazi": "yoz",      # -1
		"kanit": true,        # -1
		"asker": true,        # -1
		"itibar": 1           # -1
	})
	dene(r_asiri["ham_toplam"] == -4, "Ham toplam -4 hesaplandı")
	dene(r_asiri["toplam"] == -3, "Toplam -3'e kesildi")
	dene(r_asiri["kesildi"] == true, "kesildi bayrağı doğru")
	var kesilme_satiri := false
	for s in r_asiri["satirlar"]:
		if s["tur"] == "kesilme": kesilme_satiri = true
	dene(kesilme_satiri, "Listede kesildiği satır olarak yazar")

	# 10. Yorgunluk +1 verir
	var r_yorgun := ZAR_DEGISTIRICI.hesapla("blof", {"yorgunluk": true})
	dene(r_yorgun["toplam"] == 1, "Yorgunluk +1 verir")

	# 11. Adil terazi gönül almayı da -1 düşürür
	var r_gonul := ZAR_DEGISTIRICI.hesapla("gonul_alma", {"terazi": "adil"})
	dene(r_gonul["toplam"] == -1, "Adil terazi gönül almayı 1 düşürür")

	print("ZAR DEGISTIRICI TEST: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)
