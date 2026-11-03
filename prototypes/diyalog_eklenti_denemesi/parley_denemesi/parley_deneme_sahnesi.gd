# Parley Deneme Sahnesi (Görev 2)
# Diyalog 01 (Çiftçi) ve CHR_011 ipucu koşul prototipi
class_name ParleyDenemeSahnesi
extends Node

const DS_PATH = "res://prototypes/diyalog_eklenti_denemesi/parley_denemesi/diyalog_01_parley.ds"

signal deneme_tamamlandi(rapor: Dictionary)

var ctx: ParleyContext
var ast: ParleyDialogueSequenceAst
var son_karar: String = ""
var tansiyon: int = 2
var cevap_sayisi: int = 0
var ipucu_var: bool = false
var turkce_karakterler_gecerli: bool = false


func _ready() -> void:
	pass


func calistir_otomatik_test() -> Dictionary:
	var baslangic_ms: int = Time.get_ticks_msec()
	print("--- [PARLEY DENEMESİ BAŞLADI] ---")
	
	# 1. Dosya yükleme ve AST oluşturma
	var file := FileAccess.open(DS_PATH, FileAccess.READ)
	if not file:
		push_error("Parley .ds dosyası açılamadı: %s" % DS_PATH)
		return {"basarili": false, "hata": "dosya_yok"}
	
	var json_str := file.get_as_text()
	file.close()
	
	var json_data: Variant = JSON.parse_string(json_str)
	if not json_data is Dictionary:
		push_error("Parley JSON parse hatası")
		return {"basarili": false, "hata": "json_hatasi"}
	
	var nodes: Array = json_data.get("nodes", [])
	var edges: Array = json_data.get("edges", [])
	ast = ParleyDialogueSequenceAst.new("diyalog_01_parley", nodes, edges)
	
	ctx = ParleyContext.new()
	ctx.p_data = {
		"cevap_sayisi": 0,
		"tansiyon": 2,
		"ipucu_var": false
	}
	
	# 2. Türkçe Karakter Testi
	# Deneme cümlesi: "Işık, İzmir'den gelen ışığı çağırdı; göğsü ağrıyan kişi kapıda üşüdü."
	var turkce_cumle := "Işık, İzmir'den gelen ışığı çağırdı; göğsü ağrıyan kişi kapıda üşüdü."
	var aranan_harfler := ["ç", "ğ", "ı", "İ", "ö", "ş", "ü", "I", "i"]
	var eksik_harfler: Array[String] = []
	for h in aranan_harfler:
		if not turkce_cumle.contains(h):
			eksik_harfler.append(h)
	
	# AST içindeki türkçe düğümü doğrula
	var node_turkce: ParleyNodeAst = null
	for n in ast.nodes:
		if n.id == "node:turkce":
			node_turkce = n
			break
	
	if node_turkce and node_turkce is ParleyDialogueNodeAst:
		var rep_text: String = (node_turkce as ParleyDialogueNodeAst).text
		if rep_text == turkce_cumle and eksik_harfler.is_empty():
			turkce_karakterler_gecerli = true
			print("[PARLEY TÜRKÇE] Metin başarıyla okundu ve tüm karakterler korundu: \"%s\"" % rep_text)
		else:
			print("[PARLEY TÜRKÇE HATA] Metin eşleşmedi veya harf eksik: %s" % rep_text)
	
	# 3. Akış Testi: Start -> Açılış Repliği
	var res1: ParleyRunResult = await ParleyDialogueSequenceAst.run(ctx, ast)
	print("[PARLEY AKIŞ] Başlangıç düğümleri: %d adet" % res1.node_asts.size())
	for n in res1.node_asts:
		if n is ParleyDialogueNodeAst:
			print("  Replik [%s]: %s" % [(n as ParleyDialogueNodeAst).character, (n as ParleyDialogueNodeAst).text])
	
	# 4. Soru Ağacı ve Alt Soru Denemesi (Kimsin? -> Doğuda nereden?)
	var opt_kimsin: ParleyNodeAst = _dugum_bul("node:opt_kimsin")
	var res_kimsin: ParleyRunResult = await ParleyDialogueSequenceAst.run(ctx, ast, opt_kimsin)
	print("[PARLEY SORU] 'Kimsin?' seçildi. Sonuç düğümleri:")
	for n in res_kimsin.node_asts:
		if n is ParleyDialogueNodeAst:
			print("  Cevap: %s" % (n as ParleyDialogueNodeAst).text)
		elif n is ParleyDialogueOptionNodeAst:
			print("  Takip Sorusu: %s" % (n as ParleyDialogueOptionNodeAst).text)
	
	# Alt soru: Doğuda nereden?
	var opt_nereden: ParleyNodeAst = _dugum_bul("node:opt_nereden")
	var res_nereden: ParleyRunResult = await ParleyDialogueSequenceAst.run(ctx, ast, opt_nereden)
	for n in res_nereden.node_asts:
		if n is ParleyDialogueNodeAst:
			print("  Alt Cevap: %s" % (n as ParleyDialogueNodeAst).text)
	
	# Soru sonrası cevap sayısı kontrolü
	cevap_sayisi = int(ctx.p_data.get("cevap_sayisi", 0))
	print("[PARLEY EŞİK] Alınan cevap sayısı: %d" % cevap_sayisi)
	
	# 5. CHR Koşul Denemesi (İpucu yokken vs varken)
	# Durum A: İpucu yok
	ctx.p_data["ipucu_var"] = false
	var opt_chr: ParleyNodeAst = _dugum_bul("node:opt_chr")
	var res_chr_kilit: ParleyRunResult = await ParleyDialogueSequenceAst.run(ctx, ast, opt_chr)
	print("[PARLEY CHR KOŞUL] İpucu yokken CHR seçeneği denendi:")
	for n in res_chr_kilit.node_asts:
		if n is ParleyDialogueNodeAst:
			print("  Dallanma: %s" % (n as ParleyDialogueNodeAst).text)
	
	# Durum B: İpucu var -> Tansiyon +2 artışı
	ctx.p_data["ipucu_var"] = true
	var res_chr_acik: ParleyRunResult = await ParleyDialogueSequenceAst.run(ctx, ast, opt_chr)
	tansiyon = int(ctx.p_data.get("tansiyon", 2))
	print("[PARLEY CHR KOŞUL] İpucu varken CHR seçeneği denendi:")
	for n in res_chr_acik.node_asts:
		if n is ParleyDialogueNodeAst:
			print("  İtiraf Repliği: %s" % (n as ParleyDialogueNodeAst).text)
	print("  Tansiyon durumu: %d (Beklenen: 4)" % tansiyon)
	
	# 6. Karar ve Köy Etkisi Aksiyon Denemesi (Kabul)
	var opt_kabul: ParleyNodeAst = _dugum_bul("node:opt_kabul")
	var res_kabul: ParleyRunResult = await ParleyDialogueSequenceAst.run(ctx, ast, opt_kabul)
	son_karar = str(ctx.p_data.get("son_karar", ""))
	for n in res_kabul.node_asts:
		if n is ParleyDialogueNodeAst:
			print("  Karar Repliği: %s" % (n as ParleyDialogueNodeAst).text)
	
	var gecen_sure_ms: int = Time.get_ticks_msec() - baslangic_ms
	print("--- [PARLEY DENEMESİ TAMAMLANDI - Süre: %d ms] ---" % gecen_sure_ms)
	
	var sonuc := {
		"eklenti": "Parley",
		"sure_ms": gecen_sure_ms,
		"turkce_ok": turkce_karakterler_gecerli,
		"alt_soru_ok": res_nereden.node_asts.size() > 0,
		"chr_kosul_ok": (tansiyon == 4),
		"karar_ok": (son_karar == "kabul"),
		"cevap_sayisi": cevap_sayisi
	}
	deneme_tamamlandi.emit(sonuc)
	return sonuc


func _dugum_bul(id: String) -> ParleyNodeAst:
	for n in ast.nodes:
		if n.id == id:
			return n
	return null
