# Parley Köy Diyalog Yöneticisi (Görev 3)
# Köylülerle tıklayınca muhabbet ve köy içi sekansları Parley üzerinden çalıştırır.
class_name KoyDiyalogYoneticisi
extends RefCounted

const ParleyKoyAdaptoru = preload("res://src/diyalog/parley_koy_adaptoru.gd")

signal replik_geldi(konusan: String, metin: String, secenekler: Array)
signal diyalog_sonlandi()

static var aktif_yonetici: KoyDiyalogYoneticisi = null

var ast: ParleyDialogueSequenceAst
var ctx: ParleyContext
var koylu: Koylu
var yonetim: KoyYonetimi
var son_secenekler: Array = []
var calisiyor: bool = false


## Verilen .ds dosyasını yükler ve AST döner
static func sekans_yukle(ds_yolu: String) -> ParleyDialogueSequenceAst:
	var f := FileAccess.open(ds_yolu, FileAccess.READ)
	if not f:
		push_error("Parley sekansı açılamadı: " + ds_yolu)
		return null
	var txt := f.get_as_text()
	f.close()
	var json_val: Variant = JSON.parse_string(txt)
	if not json_val is Dictionary:
		push_error("Parley sekansı geçersiz JSON: " + ds_yolu)
		return null
	var d: Dictionary = json_val
	var title: String = str(d.get("title", "sekans"))
	var nodes: Array = d.get("nodes", [])
	var edges: Array = d.get("edges", [])
	return ParleyDialogueSequenceAst.new(title, nodes, edges)


## Köylüye tıklandığında muhabbet ağacını başlatır
func muhabbet_baslat(k: Koylu, y: KoyYonetimi = null) -> bool:
	koylu = k
	yonetim = y
	var ds_yolu := "res://data/parley/koy/koylu_muhabbet_genel.ds"
	if koylu:
		var ad_id := ""
		if not koylu.adli_id.is_empty():
			ad_id = String(koylu.adli_id).to_lower()
		elif not koylu.ad.is_empty():
			ad_id = koylu.ad.to_lower().replace(" ", "_").replace("ı", "i").replace("ş", "s").replace("ç", "c").replace("ğ", "g").replace("ö", "o").replace("ü", "u")
			
		var ozel_yol := "res://data/parley/koy/koylu_muhabbet_%s.ds" % ad_id
		if FileAccess.file_exists(ozel_yol):
			ds_yolu = ozel_yol
		elif koylu.bayrak_var(&"acl01_es") or ad_id == "es" or ad_id.contains("es"):
			ds_yolu = "res://data/parley/koy/koylu_muhabbet_es.ds"
		elif ad_id.contains("karaca"):
			ds_yolu = "res://data/parley/koy/koylu_muhabbet_karaca_usta.ds"
		elif ad_id.contains("ayse"):
			ds_yolu = "res://data/parley/koy/koylu_muhabbet_ayse_baci.ds"
		elif ad_id.contains("saruca"):
			ds_yolu = "res://data/parley/koy/koylu_muhabbet_saruca_hatun.ds"
		elif ad_id.contains("hasan"):
			ds_yolu = "res://data/parley/koy/koylu_muhabbet_hasan_celebi.ds"
		elif ad_id.contains("yusuf"):
			ds_yolu = "res://data/parley/koy/koylu_muhabbet_yusuf.ds"
		elif ad_id.contains("miraen"):
			ds_yolu = "res://data/parley/koy/koylu_muhabbet_miraen.ds"
		elif ad_id.contains("thessra"):
			ds_yolu = "res://data/parley/koy/koylu_muhabbet_thessra.ds"
		elif ad_id.contains("sorhan"):
			ds_yolu = "res://data/parley/koy/koylu_muhabbet_sorhan.ds"
		elif ad_id.contains("aydogdu"):
			ds_yolu = "res://data/parley/koy/koylu_muhabbet_aydogdu.ds"
		elif ad_id.contains("nogay"):
			ds_yolu = "res://data/parley/koy/koylu_muhabbet_nogay.ds"
	
	ast = sekans_yukle(ds_yolu)
	if not ast:
		return false
		
	ctx = ParleyContext.new()
	ctx.p_data = ParleyKoyAdaptoru.baglam_olustur(koylu, yonetim)
	calisiyor = true
	aktif_yonetici = self
	
	_ilerlet(null)
	return true


## Belirli bir sekansı (örn: seq_degirmen_kitlik) başlatır
func sekans_baslat(sekans_adi: String, y: KoyYonetimi = null) -> bool:
	yonetim = y
	koylu = null
	var ds_yolu := "res://data/parley/koy/" + sekans_adi + ".ds"
	if not FileAccess.file_exists(ds_yolu) and not sekans_adi.begins_with("sekans_"):
		ds_yolu = "res://data/parley/koy/sekans_" + sekans_adi + ".ds"
	ast = sekans_yukle(ds_yolu)
	if not ast:
		return false
		
	ctx = ParleyContext.new()
	ctx.p_data = {
		"havadisler": ["harami", "kitlik"],
		"baskil_havadis": "harami",
		"moral": 60,
		"uygulanan_etkiler": []
	}
	calisiyor = true
	aktif_yonetici = self
	
	_ilerlet(null)
	return true


## Bir seçeneği tıklandığında akışı sürdürür
func secenek_sec(secenek_d: ParleyNodeAst) -> void:
	if not calisiyor or not ast:
		return
	_ilerlet(secenek_d)


func _ilerlet(secilen: ParleyNodeAst = null) -> void:
	if not calisiyor:
		return
	var res: ParleyRunResult = await ParleyDialogueSequenceAst.run(ctx, ast, secilen)
	if not res or res.node_asts.is_empty():
		bitir()
		return
		
	var son_replik: ParleyDialogueNodeAst = null
	var secenekler: Array = []
	var bitti := false
	
	for n in res.node_asts:
		if n is ParleyDialogueNodeAst:
			son_replik = n as ParleyDialogueNodeAst
		elif n is ParleyDialogueOptionNodeAst:
			secenekler.append(n)
		elif n is ParleyEndNodeAst:
			bitti = true
			
	if son_replik and secenekler.is_empty():
		var sonraki_res: ParleyRunResult = await ParleyDialogueSequenceAst.run(ctx, ast, son_replik)
		if sonraki_res and not sonraki_res.node_asts.is_empty():
			if ParleyDialogueSequenceAst.is_dialogue_options(sonraki_res.node_asts):
				for on in sonraki_res.node_asts:
					if on is ParleyDialogueOptionNodeAst:
						secenekler.append(on)
			elif sonraki_res.node_asts.front() is ParleyEndNodeAst:
				bitti = true
			sonraki_res.free()

	son_secenekler = secenekler
	if son_replik:
		var konusan: String = son_replik.character
		if konusan.is_empty() and koylu:
			konusan = koylu.ad
		replik_geldi.emit(konusan, son_replik.text, secenekler)
	elif not secenekler.is_empty():
		replik_geldi.emit("Seçim", "", secenekler)
	elif bitti:
		bitir()


## Diyaloğu kapatır ve etkileri uygular
func bitir() -> void:
	if not calisiyor:
		return
	calisiyor = false
	if ctx and ctx.p_data is Dictionary:
		ParleyKoyAdaptoru.etkileri_uygula(ctx.p_data, koylu, yonetim)
	diyalog_sonlandi.emit()
	if aktif_yonetici == self:
		aktif_yonetici = null
