## Görev 16 Bölüm B — İngilizce Dil ve Diyalog Entegrasyon Testi
extends SceneTree

var hata: int = 0

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error("INGILIZCE_TEST_FAIL: " + mesaj)

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	print("--- INGILIZCE ENTEGRASYON TESTI BASLADI ---")
	
	# 1. Dil Ayarı ve Desteklenen Diller
	var a := Ayarlar.new("user://test_ingilizce_ayar.cfg")
	a.yukle()
	DilAyari.bagla(a)
	DilAyari.sec(a, "tr")
	var diller := DilAyari.diller()
	_kontrol(diller.has("tr"), "tr desteklenmeli")
	_kontrol(diller.has("en"), "en desteklenmeli")
	_kontrol(diller[0] == "tr", "varsayılan dil tr olmalı")
	
	# 2. Türkçe Varsayılan Metinler
	_kontrol(tr("arayuz.ayarlar.baslik") == "Ayarlar", "TR ayarlar başlık")
	_kontrol(tr("arayuz.dil.tr") == "Türkçe", "TR dil tr etiketi")
	_kontrol(tr("arayuz.dil.en") == "İngilizce", "TR dil en etiketi")
	
	# 3. İngilizce Çeviriler (metinler.csv)
	DilAyari.sec(a, "en")
	_kontrol(tr("arayuz.ayarlar.baslik") == "Settings", "EN ayarlar başlık")
	_kontrol(tr("arayuz.dil.tr") == "Turkish", "EN dil tr etiketi")
	_kontrol(tr("arayuz.dil.en") == "English", "EN dil en etiketi")
	_kontrol(tr("arayuz.duraklat.baslik") == "Paused", "EN duraklat başlık")
	_kontrol(tr("hafiza.bos.karar") == "No decision has been rendered at the gate tonight.", "EN hafıza defteri boş sayfa")
	_kontrol(tr("karakter.aydogdu.ad") == "Aydoğdu", "EN karakter adı Türkçe ile aynı kalmalı (YER-17)")
	
	# 4. İngilizce Kapı Diyaloğu (data/diyalog/en/diyalog_01_20.json)
	var kapi_yol := "res://data/diyalog/diyalog_01_20.json"
	if TranslationServer.get_locale() == "en" and FileAccess.file_exists("res://data/diyalog/en/diyalog_01_20.json"):
		kapi_yol = "res://data/diyalog/en/diyalog_01_20.json"
	_kontrol(kapi_yol == "res://data/diyalog/en/diyalog_01_20.json", "EN kapı diyaloğu yolu")
	var kapi_metin := FileAccess.get_file_as_string(kapi_yol)
	var kapi_json: Variant = JSON.parse_string(kapi_metin)
	_kontrol(kapi_json is Array and kapi_json.size() >= 20, "EN kapı JSON geçerli dizi")
	if kapi_json is Array and not kapi_json.is_empty():
		var ilk: Dictionary = kapi_json[0]
		_kontrol(ilk.has("sahne") and ilk.has("sorular"), "EN diyalog düğüm yapısı tam")
	
	# 5. İngilizce Eş Yorumları (data/diyalog/en/es_kapi_dusunceleri.json)
	var es_yol := "res://data/diyalog/en/es_kapi_dusunceleri.json"
	_kontrol(FileAccess.file_exists(es_yol), "EN eş kapı düşünceleri dosyası mevcut")
	var es_txt := FileAccess.get_file_as_string(es_yol)
	var es_json: Variant = JSON.parse_string(es_txt)
	_kontrol(es_json is Dictionary and es_json.has("diyalog_01"), "EN eş kapı JSON geçerli")
	
	# 6. İngilizce Parley Sekansları (data/parley/en/koy/*.ds)
	var ds_yolu := "res://data/parley/koy/koylu_muhabbet_genel.ds"
	var en_ds_yolu := ds_yolu.replace("res://data/parley/koy/", "res://data/parley/en/koy/")
	_kontrol(FileAccess.file_exists(en_ds_yolu), "EN Parley sekansı mevcut")
	var seq = KoyDiyalogYoneticisi.sekans_yukle(ds_yolu)
	_kontrol(seq != null, "EN Parley AST başarıyla derlendi")
	
	# 7. Akşam Sohbeti İngilizce Verisi (data/soz/en/aksam_konulari.json)
	var aksam_yol := "res://data/soz/en/aksam_konulari.json"
	_kontrol(FileAccess.file_exists(aksam_yol), "EN akşam konuları dosyası mevcut")
	var aksam_txt := FileAccess.get_file_as_string(aksam_yol)
	var aksam_json: Variant = JSON.parse_string(aksam_txt)
	_kontrol(aksam_json is Dictionary and aksam_json.has("konular"), "EN akşam konuları geçerli")
	
	# Dili tekrar Türkçe varsayılana getir
	DilAyari.sec(a, "tr")
	_kontrol(TranslationServer.get_locale() == "tr", "locale tr'ye döndü")
	
	print("INGILIZCE ENTEGRASYON TESTI: %s (%d hata)" % ["GECTI" if hata == 0 else "KALDI", hata])
	quit(0 if hata == 0 else 1)
