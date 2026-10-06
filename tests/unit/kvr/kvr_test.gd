## KVR sözleşmesi: eski kaynak/katalog uyumu, yeni alanlar ve Resource roundtrip.
extends SceneTree

var hata := 0

func _initialize() -> void:
	var k := KarakterVerisi.new()
	k.entity_id = &"CHR_001"
	k.ad = "Hamza"
	k.fraksiyon = &"Kızıl Karga"
	k.sinif = &"ciftci"
	k.en_erken_tur = 3
	k.sonraki_spawns = {"on_accept": {"entity_id": &"CHR_004", "offset": 4}, "on_reject": {"entity_id": &"CHR_005", "offset": 3}, "on_bribe": {"entity_id": &"CHR_006", "offset": 2}, "on_jail": {"entity_id": &"CHR_007", "offset": 5}}
	k.gecikmeli_etkiler = [{"tur_offset": 3, "hedef_bina": "Ahir", "olay_id": "GeceBicaklamasi", "stat_etkisi": {"Guvenlik": -3}}]
	for karar in ["kabul", "gonullu_ret", "zorunlu_ret", "rusvet", "kisla"]:
		k.karar_matrisi[karar] = {"stat_etkisi": {"Refah": 1, "Erzak": -2, "Guvenlik": 3, "Moral": -1, "Saglik": 0}, "muhafiz_akce": 4 if karar == "rusvet" else 0, "esyalar": []}
	k.diyalog_dugumleri = {"00": {"replik_anahtari": &"CHR_001_DUGUM_00_REPLIK", "secenekler": [{"metin_anahtari": &"CHR_001_DUGUM_00_SEC_1_METIN", "hedef": "1.1", "tansiyon_delta": 2}]}, "1.1": {"replik_anahtari": &"CHR_001_DUGUM_1_1_REPLIK", "secenekler": []}}
	k.gorsel_hata_ipucu = &"Clue_Görsel_CHR001_KukurtYanigi"
	k.baslangic_tansiyonu = 3
	k.animasyon_anahtarlari["Panic"] = &"saldirgan_panik"
	k.obje_1 = {"aciklama": "Çakmak muhafazası", "uretilen_ipucu": &"Clue_CHR001_KavliCakmak"}
	k.obje_2 = {"aciklama": "Oyulmuş odun", "uretilen_ipucu": &"Clue_CHR001_KatranliBez"}
	k.secere_matrisi = {"Doğum_Yeri": "Taşlıbel", "Aile_Bağı": "İlyas", "Kırılma_Olayı": "Kuraklık"}
	k.koy_ici_davranis = {"Gündüz_Döngüsü": "Odunluk", "Gece_Döngüsü": "Erzak Ambarı"}
	_kontrol(k.id == &"chr_001" and k.entity_id == &"CHR_001", "Kimlik adaptörü")
	_kontrol(k.en_erken_gece == 3, "Yeni tur eski kadroya bağlı")
	k.en_erken_gece = 4
	_kontrol(k.en_erken_tur == 4, "Eski tur yeni sözleşmeye bağlı")
	var yol := "user://kvr-test.tres"
	_kontrol(ResourceSaver.save(k, yol) == OK, "Resource kaydı")
	var geri := ResourceLoader.load(yol, "", ResourceLoader.CACHE_MODE_IGNORE) as KarakterVerisi
	_kontrol(geri != null and geri.ad == "Hamza" and geri.fraksiyon == &"Kızıl Karga" and geri.en_erken_tur == 4 and geri.entity_id == &"CHR_001", "Yeni alanlar roundtrip")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(yol))
	var sozlesme := preload("res://src/veri/chr_sozlesmesi.gd")
	_kontrol(sozlesme.spawn_hatalari(geri.sonraki_spawns).is_empty() and geri.sonraki_spawns == k.sonraki_spawns, "Dört karar spawn zinciri roundtrip")
	_kontrol(sozlesme.spawn_hatalari({"on_other": {"entity_id": "chr_4", "offset": -1}}).size() == 3, "Koşul/kimlik/gecikme reddi")
	_kontrol(sozlesme.gecikmeli_hatalari(geri.gecikmeli_etkiler).is_empty() and geri.gecikmeli_etkiler[0]["stat_etkisi"]["Guvenlik"] == -3, "Gecikmeli negatif etki roundtrip")
	_kontrol(sozlesme.gecikmeli_hatalari([{"tur_offset": 0, "hedef_bina": "", "olay_id": "", "stat_etkisi": {"Akce": -3}}]).size() == 4, "Gecikmeli hatalı tur/bina/olay/stat reddi")
	_kontrol(sozlesme.karar_hatalari(geri.karar_matrisi).is_empty(), "Beş karar/beş stat roundtrip")
	_kontrol(geri.karar_verisi(&"rusvet")["muhafiz_akce"] == 4 and geri.etki(&"rusvet").is_empty(), "Kişisel rüşvet eski kamu barlarına sızmıyor")
	_kontrol(sozlesme.stat_hatalari({"Akce": 4, "Saglik": "2"}).size() == 2, "Akçe stat değil; yanlış stat tipi reddi")
	_kontrol(sozlesme.bayrak_hatalari(geri.sorgu_bayraklari).is_empty(), "Dört bayrak roundtrip")
	var sorgu := geri.yeni_sorgu_bayraklari()
	sorgu["Flag_Kilitlendi"] = true
	_kontrol(not geri.sorgu_bayraklari["Flag_Kilitlendi"], "Sorgu bayrağı kaynağa sızmıyor")
	sorgu.erase("Flag_Kimlik_Cozuldu")
	sorgu["uydurma"] = false
	_kontrol(sozlesme.bayrak_hatalari(sorgu).size() == 2, "Eksik/tanımsız bayrak reddi")
	_kontrol(sozlesme.diyalog_hatalari(geri.diyalog_dugumleri).is_empty(), "Geçerli düğüm zinciri roundtrip")
	var kopya := geri.diyalog_dugumu(&"00")
	kopya["secenekler"][0]["hedef"] = "yok"
	kopya["secenekler"][0]["tansiyon_delta"] = "2"
	_kontrol(geri.diyalog_dugumu(&"00")["secenekler"][0]["hedef"] == "1.1", "Sorgu kaynak düğümü değiştirmiyor")
	_kontrol(sozlesme.diyalog_hatalari({"00": kopya}).size() == 2, "Kırık hedef ve delta tipi reddediliyor")
	_kontrol(geri.gorsel_hata_ipucu == k.gorsel_hata_ipucu and geri.baslangic_tansiyonu == 3, "Görsel ipucu ve başlangıç roundtrip")
	for deger in [-1, 0, 3, 4, 7, 8, 10, 11]:
		var beklenen := &"Idle" if deger < 4 else &"Stressed" if deger < 8 else &"saldirgan_panik"
		_kontrol(geri.tansiyon_animasyonu(deger) == beklenen, "Poz eşik sınırı %d" % deger)
	_kontrol(geri.obje_ipucu(1) == &"Clue_CHR001_KavliCakmak" and geri.obje_ipucu(2) == &"Clue_CHR001_KatranliBez", "İki heybe ipucu roundtrip")
	_kontrol(geri.obje_ipucu(0) == &"" and geri.obje_ipucu(3) == &"", "Geçersiz nesne başka nesneye yönlenmiyor")
	_kontrol(geri.secere_matrisi == k.secere_matrisi and geri.koy_ici_davranis == k.koy_ici_davranis, "Şecere ve davranış kaynak anahtarları roundtrip")
	geri.secere_matrisi["Doğum_Yeri"] = "başka"
	_kontrol(k.secere_matrisi["Doğum_Yeri"] == "Taşlıbel", "Yüklenen şecere asıl veriyi değiştirmiyor")
	var katalog := Katalog.new()
	_kontrol(katalog.yukle() == Katalog.Durum.HAZIR, "Eski katalog yükleniyor")
	var eski := katalog.karakter(&"chr_001")
	_kontrol(eski.entity_id == &"CHR_001" and eski.en_erken_tur == eski.en_erken_gece, "Mevcut CHR kaydı yeni API ile okunuyor")
	var adli := katalog.karakter(&"miraen")
	_kontrol(adli.entity_id == &"miraen", "CHR dışı eski kimlik korunuyor")
	print("KVR TEST: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
