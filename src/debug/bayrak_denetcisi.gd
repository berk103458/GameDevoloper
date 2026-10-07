class_name BayrakDenetcisi
extends RefCounted

static func sorgu(ana: Node) -> ChrSorgusu:
	if not NpcCagirma.uygun(ana):
		return null
	var g: Gelen = ana.get("_ekran").get("_gelen")
	return g.chr_sorgusu() as ChrSorgusu if g != null else null

static func degistir(s: ChrSorgusu, anahtar: String, acik: bool) -> Dictionary:
	if s == null or not anahtar.begins_with("Flag_") or not s.bayraklar.has(anahtar):
		return {"ok": false, "neden": "Aktif sorgunun tanımlı Flag anahtarı gerekli."}
	# KAP-08 kalıcı kilit sözleşmesi debug arayüzünde de korunur.
	if anahtar == "Flag_Kilitlendi" and s.bayraklar[anahtar] and not acik:
		return {"ok": false, "neden": "Kalıcı panik kilidi bu ziyarette kaldırılamaz."}
	s.bayraklar[anahtar] = acik
	return {"ok": true, "anahtar": anahtar, "acik": acik}

static func uygula(ana: Node, beklenen: ChrSorgusu, anahtar: String, acik: bool) -> Dictionary:
	var s := sorgu(ana)
	if s == null or s != beklenen:
		return {"ok": false, "neden": "Ziyaret değişti veya sorgu hazır değil; eski denetçi değişikliği uygulanmadı."}
	var sonuc := degistir(s, anahtar, acik)
	if sonuc["ok"]:
		var ekran: Node = ana.get("_ekran")
		ekran.call("_karar_goster" if ekran.get("evre") == &"karar" else "_sohbet_goster")
	return sonuc
