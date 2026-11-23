# Parley Köy Diyalog Yöneticisi (Görev 3)
# Köylülerle tıklayınca muhabbet ve köy içi sekansları Parley üzerinden çalıştırır.
class_name KoyDiyalogYoneticisi
extends RefCounted

const ParleyKoyAdaptoru = preload("res://src/diyalog/parley_koy_adaptoru.gd")
const TUCCAR_SOZU := "res://data/soz/koy_tuccari.json"

signal replik_geldi(konusan: String, metin: String, secenekler: Array)
signal diyalog_sonlandi()

static var aktif_yonetici: KoyDiyalogYoneticisi = null

var ast: ParleyDialogueSequenceAst
var ctx: ParleyContext
var koylu: Koylu
var yonetim: KoyYonetimi
var son_secenekler: Array = []
var calisiyor: bool = false
var _bosta_soylendi := false
var _soylenti_soylendi := false
var _tuccar_sozu: SozMotoru


## Verilen .ds dosyasını yükler ve AST döner
static func sekans_yukle(ds_yolu: String) -> ParleyDialogueSequenceAst:
	if TranslationServer.get_locale() == "en":
		var en_yol := ds_yolu.replace("res://data/parley/koy/", "res://data/parley/en/koy/")
		if FileAccess.file_exists(en_yol):
			ds_yolu = en_yol
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
	if koylu != null and koylu.bayrak_var(SevilenYuz.MASKE_BAYRAGI):
		SevilenYuz.kimlik_ac(koylu)
	_bosta_soylendi = false
	_soylenti_soylendi = false
	yonetim = y
	if koylu != null and (koylu.sinif == &"esnaf" or "tüccar" in koylu.ad.to_lower() or "tuccar" in koylu.ad.to_lower()):
		return _tuccar_baslat()
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


func _tuccar_baslat() -> bool:
	var dosya: Variant = JSON.parse_string(FileAccess.get_file_as_string(TUCCAR_SOZU))
	_tuccar_sozu = SozMotoru.new()
	if not _tuccar_sozu.yukle(dosya).get("basarili", false):
		_tuccar_sozu = null
		return false
	calisiyor = true
	aktif_yonetici = self
	var secenekler: Array[Dictionary] = []
	for secenek in _tuccar_sozu.mevcut_secenekler():
		secenekler.append({"id": secenek.id, "metin": SozMotoru.kapi_metni(secenek.metin)})
	replik_geldi.emit(koylu.ad, SozMotoru.kapi_metni(_tuccar_sozu.mevcut_satir()), secenekler)
	return true


func soz_secenek(id: String) -> void:
	if not calisiyor or _tuccar_sozu == null:
		return
	var sonuc := _tuccar_sozu.sec(id)
	if not sonuc.get("basarili", false):
		return
	var satir := SozMotoru.kapi_metni(String(sonuc.satir))
	if id == "opt_havadis":
		var baglam := ParleyKoyAdaptoru.baglam_olustur(koylu, yonetim)
		var soylenti := ParleyKoyAdaptoru.canli_soylenti_satiri(baglam)
		if not soylenti.is_empty():
			satir = soylenti
	elif yonetim != null:
		var etki := SozMotoru.is_gucu_etkisi(yonetim, "tuccar", id)
		yonetim.set_meta(&"koy_tuccar_soz_karari", {"id": id, "etki": etki})
	replik_geldi.emit(koylu.ad, satir, [])
	bitir()


func secenek_sec(secenek_d: ParleyNodeAst) -> void:
	if not calisiyor or not ast:
		return
	_ilerlet(secenek_d)


func _ilerlet(secilen: ParleyNodeAst = null) -> void:
	if not calisiyor:
		return
	var res: ParleyRunResult = await ParleyDialogueSequenceAst.run(ctx, ast, secilen)
	if not res or res.node_asts.is_empty():
		if res: res.free()
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
		if sonraki_res: sonraki_res.free()

	son_secenekler = secenekler
	if son_replik:
		var konusan: String = son_replik.character
		if konusan.is_empty() and koylu:
			konusan = koylu.ad
		var metin := son_replik.text
		if not _soylenti_soylendi and koylu != null and ctx != null and ctx.p_data is Dictionary:
			var rid := String(son_replik.id)
			if rid.contains("havadis") or rid.contains("karar"):
				var soylenti_soz := ParleyKoyAdaptoru.canli_soylenti_satiri(ctx.p_data)
				if not soylenti_soz.is_empty():
					metin = soylenti_soz if rid == "node:rep_havadis_sakin" else soylenti_soz + "\n" + metin
					_soylenti_soylendi = true
		if not _bosta_soylendi and koylu != null:
			var bosta := preload("res://src/koy/bosta_kalma.gd").sohbet_satiri(yonetim, koylu)
			if not bosta.is_empty():
				metin = bosta + "\n" + metin
			_bosta_soylendi = true
		replik_geldi.emit(konusan, metin, secenekler)
	elif not secenekler.is_empty():
		replik_geldi.emit("Seçim", "", secenekler)
	elif bitti:
		bitir()
	res.free()


static func sohbet_soylenti_satiri(k: Koylu, y: KoyYonetimi) -> String:
	return NeDuydun.sohbet_soylenti_satiri(y, k)


func canli_soylenti_metni() -> String:
	if ctx != null and ctx.p_data is Dictionary:
		return ParleyKoyAdaptoru.canli_soylenti_satiri(ctx.p_data)
	return ""


## Diyaloğu kapatır ve etkileri uygular
func bitir() -> void:
	if not calisiyor:
		return
	calisiyor = false
	if ctx and ctx.p_data is Dictionary:
		ParleyKoyAdaptoru.etkileri_uygula(ctx.p_data, koylu, yonetim)
	if ctx:
		ctx.free()
		ctx = null
	ast = null
	son_secenekler.clear()
	_tuccar_sozu = null
	diyalog_sonlandi.emit()
	if aktif_yonetici == self:
		aktif_yonetici = null
