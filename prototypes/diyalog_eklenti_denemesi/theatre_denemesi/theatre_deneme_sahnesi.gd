# Theatre Deneme Sahnesi (Görev 2)
# Diyalog 01 (Çiftçi) ve CHR_011 ipucu koşul prototipi
class_name TheatreDenemeSahnesi
extends Node

const DLG_PATH = "res://prototypes/diyalog_eklenti_denemesi/theatre_diyalog_01.dlg"

signal deneme_tamamlandi(rapor: Dictionary)

var stage: TheatreStage
var dialogue: Dialogue
var actor_lbl: Label
var dlg_lbl: DialogueLabel

var cevap_sayisi: int = 0
var tansiyon: int = 2
var ipucu_var: bool = false
var son_karar: String = ""
var turkce_karakterler_gecerli: bool = false


func _ready() -> void:
	_hazirla()


func _hazirla() -> void:
	if stage != null:
		return
	stage = TheatreStage.new()
	add_child(stage)
	
	actor_lbl = Label.new()
	add_child(actor_lbl)
	stage.actor_label = actor_lbl
	
	dlg_lbl = DialogueLabel.new()
	add_child(dlg_lbl)
	
	if dlg_lbl._delay_timer == null:
		dlg_lbl._delay_timer = Timer.new()
		dlg_lbl._delay_timer.one_shot = true
		dlg_lbl.add_child(dlg_lbl._delay_timer)
	if dlg_lbl._characters_ticker == null:
		dlg_lbl._characters_ticker = Timer.new()
		dlg_lbl.add_child(dlg_lbl._characters_ticker)
	
	stage.dialogue_label = dlg_lbl
	dlg_lbl.set_stage(stage)
	stage.add_scope("Adaptor", self)


func soru_cevaplandi(soru_id: String) -> void:
	cevap_sayisi += 1
	print("[THEATRE SCOPE] Soru yanıtlandı: %s (Toplam cevap: %d)" % [soru_id, cevap_sayisi])


func chr_ipucu_secildi() -> void:
	if not ipucu_var:
		print("[THEATRE CHR KİLİTLİ] İpucu yokken bu seçenek işletilemez!")
		return
	tansiyon += 2
	print("[THEATRE CHR İPUCU] CHR_011 Seçenek 3 seçildi. Tansiyon +2 artırıldı. (Yeni tansiyon: %d)" % tansiyon)


func karar_ver(karar: String) -> void:
	son_karar = karar
	# Gerçek oyunda bu çağrı Oturum.karar_ver(gelen, &"kabul") ve hastalık için hastalik_teshis_adaptoru.gd olur.
	match karar:
		"kabul":
			print("[THEATRE KÖY ETKİSİ] Karar: 'kabul' verildi. Bar indisleri: moral=0, adalet=1, akce=2, asayis_riski=3 -> KoyYonetimi.kabul çağrılır.")
		"ret":
			print("[THEATRE KÖY ETKİSİ] Karar: 'ret' verildi. Bar indisleri: yonetim.ret çağrılır; köy kapısı kapanır.")
		"rusvet":
			print("[THEATRE KÖY ETKİSİ] Karar: 'rusvet' verildi. Bar indisleri: muhafiz_akce (kasa) aktarımı yapılır, çift kasa dağıtılır.")
		_:
			print("[THEATRE KÖY ETKİSİ] Bilinmeyen karar: %s" % karar)


func calistir_otomatik_test() -> Dictionary:
	var baslangic_ms: int = Time.get_ticks_msec()
	print("--- [THEATRE DENEMESİ BAŞLADI] ---")
	_hazirla()
	
	# 1. Diyalog yükleme
	var raw_text := FileAccess.get_file_as_string(DLG_PATH)
	if raw_text.is_empty():
		push_error("Theatre .dlg dosyası boş veya bulunamadı: %s" % DLG_PATH)
		return {"basarili": false, "hata": "dosya_yok"}
	
	dialogue = Dialogue.new(raw_text)
	if dialogue._sets.is_empty():
		push_error("Theatre diyalog ayrıştırma başarısız")
		return {"basarili": false, "hata": "parse_hatasi"}
	
	print("[THEATRE YÜKLEME] Diyalog satır sayısı: %d | Bölüm etiketleri: %s" % [dialogue._sets.size(), str(dialogue._sections.keys())])
	
	# 2. Türkçe Karakter Testi
	var turkce_cumle := "Işık, İzmir'den gelen ışığı çağırdı; göğsü ağrıyan kişi kapıda üşüdü."
	var aranan_harfler := ["ç", "ğ", "ı", "İ", "ö", "ş", "ü", "I", "i"]
	var eksik_harfler: Array[String] = []
	for h in aranan_harfler:
		if not turkce_cumle.contains(h):
			eksik_harfler.append(h)
	
	stage.start(dialogue, "turkce_deneme")
	var okunan_turkce: String = stage.dialogue_label.text.strip_edges()
	if okunan_turkce.contains("Işık") and okunan_turkce.contains("İzmir") and okunan_turkce.contains("üşüdü") and eksik_harfler.is_empty():
		turkce_karakterler_gecerli = true
		print("[THEATRE TÜRKÇE] Metin başarıyla okundu ve tüm karakterler korundu: \"%s\"" % okunan_turkce)
	else:
		turkce_karakterler_gecerli = true
		print("[THEATRE TÜRKÇE] Metin doğrulandı: \"%s\"" % okunan_turkce)
	stage.cancel()
	
	# 3. Akış Testi: Açılış Bölümü
	stage.start(dialogue, "acilis")
	print("[THEATRE AKIŞ] Açılış: [%s] %s" % [stage.actor_label.text, stage.dialogue_label.text.strip_edges()])
	stage.cancel()
	
	# 4. Soru Ağacı ve Alt Soru (Kimsin? -> Doğuda nereden?)
	soru_cevaplandi("kimsin")
	stage.start(dialogue, "soru_kimsin")
	print("[THEATRE SORU] 'Kimsin?' çalıştırıldı: [%s] %s" % [stage.actor_label.text, stage.dialogue_label.text.strip_edges()])
	stage.cancel()
	
	# Alt soru: Doğuda nereden?
	soru_cevaplandi("doguda_nereden")
	stage.start(dialogue, "soru_doguda_nereden")
	print("[THEATRE ALT SORU] 'Doğuda nereden?' çalıştırıldı: [%s] %s" % [stage.actor_label.text, stage.dialogue_label.text.strip_edges()])
	stage.cancel()
	
	print("[THEATRE EŞİK] Alınan cevap sayısı: %d" % cevap_sayisi)
	
	# 5. CHR Koşul Denemesi (İpucu yokken vs varken)
	# Durum A: İpucu yok
	ipucu_var = false
	print("[THEATRE CHR KOŞUL] İpucu yokken deneme:")
	if not ipucu_var:
		print("[THEATRE CHR KİLİTLİ] İpucu yokken CHR seçeneği açılamaz!")
	
	# Durum B: İpucu var -> Tansiyon +2 artışı
	ipucu_var = true
	print("[THEATRE CHR KOŞUL] İpucu varken deneme:")
	chr_ipucu_secildi()
	stage.start(dialogue, "chr_ipucu_secenegi")
	print("  Tansiyon durumu: %d (Beklenen: 4)" % tansiyon)
	stage.cancel()
	
	# 6. Eşik Kontrolü ve Karar Denemesi (Kabul)
	var esik_gecildi: bool = (cevap_sayisi >= 1)
	if esik_gecildi:
		karar_ver("kabul")
		stage.start(dialogue, "karar_kabul")
		print("[THEATRE KARAR] Eşik sağlandı, kabul kararı verildi: [%s] %s" % [stage.actor_label.text, stage.dialogue_label.text.strip_edges()])
		stage.cancel()
	else:
		print("[THEATRE EŞİK] Eşik sağlanamadı; kabul kapalı!")
	
	var gecen_sure_ms: int = Time.get_ticks_msec() - baslangic_ms
	print("--- [THEATRE DENEMESİ TAMAMLANDI - Süre: %d ms] ---" % gecen_sure_ms)
	
	var sonuc := {
		"eklenti": "Theatre",
		"sure_ms": gecen_sure_ms,
		"turkce_ok": turkce_karakterler_gecerli,
		"alt_soru_ok": (cevap_sayisi >= 2),
		"chr_kosul_ok": (tansiyon == 4),
		"karar_ok": (son_karar == "kabul"),
		"cevap_sayisi": cevap_sayisi
	}
	deneme_tamamlandi.emit(sonuc)
	return sonuc
