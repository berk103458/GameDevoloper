## Debug atlama: mevcut kuyruğun sonuçları gerçek karar API'sinden, yalnız bir kez.
class_name KapiAtlamaAdaptoru
extends RefCounted

static func uygun(ana: Node) -> bool:
	if not is_instance_valid(ana) or ana.get("oturum") == null:
		return false
	var ekran: Node = ana.get("_ekran")
	if not is_instance_valid(ekran) or ekran.get_script() == null:
		return false
	if ekran.get_script().get_global_name() != "KapiEkrani" or ekran.get_meta(&"admin_kapi_atlandi", false):
		return false
	if ana.get("_kapi_yukleniyor"):
		return false
	for n in ekran.find_children("*", "CanvasLayer", true, false):
		if n is VarlikYuklemePaneli:
			return false
	return true

static func atla(ana: Node, tohum: int = 0) -> Dictionary:
	if not uygun(ana):
		return {"ok": false, "neden": "Kapı nöbeti hazır değil veya zaten tamamlandı."}
	var ekran: Node = ana.get("_ekran")
	var o: Oturum = ana.get("oturum")
	ekran.set_meta(&"admin_kapi_atlandi", true)
	var bekleyenler: Array[Gelen] = []
	var gelen: Gelen = ekran.get("_gelen")
	var biten: Gelen = ekran.get_meta(&"sonuclanan_gelen") if ekran.has_meta(&"sonuclanan_gelen") else null
	if gelen != null and gelen != biten:
		bekleyenler.append(gelen)
	for g: Gelen in ekran.get("_kuyruk"):
		if g != biten and g not in bekleyenler:
			bekleyenler.append(g)
	var rng := RandomNumberGenerator.new()
	if tohum == 0:
		rng.randomize()
	else:
		rng.seed = tohum
	var sonuc := {"ok": true, "toplam": bekleyenler.size(), "kabul": 0, "ret": 0}
	for g in bekleyenler:
		var sorgu := g.chr_sorgusu()
		var kabul_acik: bool = sorgu == null or (sorgu.tansiyon < 8 and sorgu.karar_acik(&"kabul"))
		var karar: StringName = &"kabul" if kabul_acik and rng.randf() >= 0.5 else &"ret"
		if g != gelen:
			o.ziyaret_basladi(g)
		o.karar_ver(g, karar)
		sonuc[String(karar)] += 1
	# UI'daki eski sinyal/animasyonlar tekrar karar üretemeden sahne değiştirilir.
	ekran.get("_kuyruk").clear()
	ekran.set("_gelen", null)
	ana.call("_koye_git")
	return sonuc
