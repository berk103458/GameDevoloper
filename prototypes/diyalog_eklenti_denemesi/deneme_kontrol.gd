# Görev 2 — Diyalog Eklentileri Deneme Kontrolörü (Parley ve Theatre Karşılaştırması)
# Antigravity (3 Kasım 2026)
extends SceneTree

const ParleySahnesi = preload("res://prototypes/diyalog_eklenti_denemesi/parley_denemesi/parley_deneme_sahnesi.gd")
const TheatreSahnesi = preload("res://prototypes/diyalog_eklenti_denemesi/theatre_denemesi/theatre_deneme_sahnesi.gd")


func _init() -> void:
	print("\n========================================================")
	print("  GÖREV 2: DİYALOG EKLENTİLERİ DENEMESİ VE KARŞILAŞTIRMA  ")
	print("========================================================\n")
	_calistir()


func _calistir() -> void:
	var root_node := Node.new()
	root.add_child(root_node)
	
	# --- 1. PARLEY TESTİ ---
	var parley := ParleySahnesi.new()
	root_node.add_child(parley)
	var parley_sonuc: Dictionary = await parley.calistir_otomatik_test()
	
	print("\n--------------------------------------------------------\n")
	
	# --- 2. THEATRE TESTİ ---
	var theatre := TheatreSahnesi.new()
	root_node.add_child(theatre)
	var theatre_sonuc: Dictionary = await theatre.calistir_otomatik_test()
	
	print("\n--------------------------------------------------------\n")
	
	# --- 3. MEVCUT SİSTEM DENEMESİ (JSON diyalog_01 + CHR_011) ---
	var mevcut_baslangic: int = Time.get_ticks_msec()
	print("--- [MEVCUT SİSTEM DENEMESİ (JSON + CHR)] ---")
	
	# JSON hattı diyalog_01
	var f := FileAccess.open("res://data/diyalog/diyalog_01_20.json", FileAccess.READ)
	var ham_json: Variant = JSON.parse_string(f.get_as_text())
	f.close()
	var d01: Dictionary = {}
	if ham_json is Array:
		for d in ham_json:
			if d.get("id") == "diyalog_01":
				d01 = d
				break
	print("[MEVCUT JSON] diyalog_01 bulundu. Açılış: \"%s\"" % d01.get("acilis", ""))
	print("[MEVCUT JSON] Soru sayısı: %d | Eşik: %s" % [d01.get("sorular", []).size(), str(d01.get("esik", []))])
	
	# CHR hattı CHR_011
	var chr_res: KarakterVerisi = load("res://data/chr_runtime/CHR_011.tres")
	print("[MEVCUT CHR] CHR_011 yüklendi: %s (%s). Başlangıç tansiyonu: %d" % [
		chr_res.ad, chr_res.sinif, chr_res.baslangic_tansiyonu
	])
	var dugum_00: Dictionary = chr_res.diyalog_dugumleri.get("00", {})
	var secenekler: Array = dugum_00.get("secenekler", [])
	print("[MEVCUT CHR] Düğüm 00 seçenek sayısı: %d. Seçenek 3 tansiyon_delta: %d, ipuçları: %s" % [
		secenekler.size(),
		secenekler[2].get("tansiyon_delta", 0) if secenekler.size() > 2 else 0,
		str(secenekler[2].get("gerekli_ipuclari", [])) if secenekler.size() > 2 else ""
	])
	var mevcut_sure_ms: int = Time.get_ticks_msec() - mevcut_baslangic
	print("--- [MEVCUT SİSTEM TAMAMLANDI - Süre: %d ms] ---" % mevcut_sure_ms)
	
	# --- 4. KARŞILAŞTIRMA VE RAPOR BASIMI ---
	print("\n========================================================")
	print("  ÜÇLÜ SİSTEM KARŞILAŞTIRMA TABLOSU")
	print("========================================================")
	print("| Ölçüt | Mevcut Sistem (JSON + CHR) | Parley (v2.1.0) | Theatre (v0.12.2) |")
	print("|---|---|---|---|")
	print("| Yazım kolaylığı | İki ayrı format: JSON'da iç içe diziler; CHR'de .md/.tres ve sözleşme doğrulaması. | Görsel editör grafı (düğümler, slotlar, bağlantılar). AST JSON tabanlı (.ds). Yazar için görsel ama karmaşık. | Düz metin (.dlg). İnsan tarafından okunabilir, YAML benzeri, GDScript içi/dışı çok pratik. |")
	print("| Dallanma | Soru ağacı 3'lü tuple (soru, cevap, [takipler]). CHR'de düğüm anahtarlı graph (00 -> 1.1 -> 1.2). | Doğal graf dallanması; DialogueOption ve Jump düğümleriyle birleşen ve ayrılan dallar tam destekli. | Satır satır lineer akış; dallanma için :section etiketleri ve koddan jump_to_section çağrıları gerekir. |")
	print("| Koşul ve değişken | JSON'da sabit eşik [0,1,1]. CHR'de tansiyon, ipucu listesi, bayraklar ve zar entegrasyonu. | Condition / Match düğümleri; harici FactInterface (.gd) sınıfları gerektirir; doğrudan değişken desteği zayıf. | GDScript Expression ve {degisken} / Scope.degisken desteği tam; kod içi değişken atama doğrudan çalışır. |")
	print("| Debuff ve köy etkisi bağlanabilirliği | Doğrudan entegre: Oturum.karar_ver, bar indisleri (moral, adalet, akçe, asayiş), hastalık teşhis adaptörü. | Action düğümü harici script çağırır (ParleyActionInterface); adaptör yazılabilir ama dış dünyadan soyut balonunda kalır. | Scope ve Caller üzerinden add_scope('Adaptor', self) ile oyun koduna doğrudan GDScript fonksiyon çağrısı yapabilir. |")
	print("| Performans ve Boyut | Çok hızlı: ~%d ms. Bellek ayak izi minimal (saf Resource / Dictionary). | Orta: ~%d ms. Editörde büyük düğüm grafı yükü, AST ağacı ve çok sayıda RefCounted nesnesi. | Hızlı: ~%d ms. Saf GDScript parser ve hafif bellek kullanımı. |" % [
		mevcut_sure_ms, parley_sonuc.get("sure_ms", 0), theatre_sonuc.get("sure_ms", 0)
	])
	print("| Karar Özeti | Mevcut iki katmanlı mimari (adsız halk JSON + adlı kişi CHR) oyunun asimetrik yapısına tam oturuyor. | Entegre etme. Graf arayüzü görsel zenginlik sunsa da kapı karar/zar/köy durum makinelerine yabancı ve ağır. | Entegre etme. Düz metin yazımı pratik olsa da mevcut CHR sorgu ağacını ve zar mantığını taşımak için yetersiz; ileride yalnız ince adaptörle yan diyaloglar için değerlendirilebilir. |")
	print("========================================================\n")
	
	var basarili: bool = (
		parley_sonuc.get("turkce_ok", false) and
		parley_sonuc.get("chr_kosul_ok", false) and
		theatre_sonuc.get("turkce_ok", false) and
		theatre_sonuc.get("chr_kosul_ok", false)
	)
	
	if basarili:
		print(">> GÖREV 2 DENEME VE TESTLERİ BAŞARIYLA GEÇTİ (0 HATA) <<\n")
		quit(0)
	else:
		printerr(">> GÖREV 2 DENEME VE TESTLERİNDE HATA BULUNDU <<\n")
		quit(1)
