extends SceneTree

var hata := 0

func dene(v: bool, mesaj: String) -> void:
	if not v:
		hata += 1
		push_error("HATA: " + mesaj)
	else:
		print("  [OK] " + mesaj)

func _initialize() -> void:
	print("\n========================================================")
	print("--- [GÖREV 6: YENİ KÖY OLAYLARI DOĞRULAMA TESTİ] ---")
	print("========================================================\n")
	
	var kat := Katalog.new()
	var durum := kat.yukle()
	dene(durum == Katalog.Durum.HAZIR, "Katalog başarıyla yüklendi (Durum.HAZIR)")
	dene(kat.hatalar.is_empty(), "Katalog hata listesi boş (0 hata)")
	
	var yeni_olay_idleri := [
		&"kavga_harman",
		&"ambarda_hirsizlik",
		&"salgin_fisiltisi",
		&"koy_dugunu",
		&"firari_cenazesi",
		&"samanlik_yangini",
		&"gece_donu",
		&"harami_elcisi"
	]
	
	var olay_haritasi := {}
	for o in kat.olaylar():
		olay_haritasi[o.id] = o
		
	for oid in yeni_olay_idleri:
		dene(olay_haritasi.has(oid), "Olay havuzunda mevcut: %s" % oid)
		if olay_haritasi.has(oid):
			var o: OlayVerisi = olay_haritasi[oid]
			dene(not o.baslik_anahtari.is_empty(), "%s: başlık anahtarı mevcut" % oid)
			dene(not o.metin_anahtari.is_empty(), "%s: metin anahtarı mevcut" % oid)
			dene(o.secenek_anahtarlari.size() == 3, "%s: 3 seçenek mevcut" % oid)
			dene(o.secenek_etkileri.size() == 3, "%s: 3 seçenek etkisi mevcut" % oid)
			for i in range(3):
				var s_anahtar: String = o.secenek_anahtarlari[i]
				var sonuc_anahtar := "%s.sonuc%d" % [o.metin_anahtari.trim_suffix(".metin"), i + 1]
				dene(not GuvenliMetin.eksik_mi(s_anahtar), "%s: %s çevirisi mevcut" % [oid, s_anahtar])
				dene(not GuvenliMetin.eksik_mi(sonuc_anahtar), "%s: %s çevirisi mevcut" % [oid, sonuc_anahtar])
	
	print("\n========================================================")
	if hata == 0:
		print("--- [YENİ OLAYLAR TEST SONUCU: BAŞARILI (0 HATA)] ---")
	else:
		print("--- [YENİ OLAYLAR TEST SONUCU: BAŞARISIZ (%d HATA)] ---" % hata)
	print("========================================================\n")
	quit(hata)
