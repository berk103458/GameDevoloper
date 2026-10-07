## Debug köy/kapı kayıt noktası; normal kayıt ve geçici slot birbirinden bağımsızdır.
class_name DurumAnlikGoruntusu
extends RefCounted

var slot := GuvenliKayit.new("user://debug_snapshot.json")

func al(o: Oturum, kamera: Dictionary = {}, kapi: Dictionary = {}) -> Dictionary:
	if o == null or o.yonetim.son != "" or o.yonetim.has_meta(GeceDeneyi.META):
		return {"ok": false, "neden": "Canlı ve deney dışında bir köy gerekli."}
	var veri := o.kaydet()
	veri["debug_snapshot"] = {"surum": 1, "faz": "koy" if kapi.is_empty() else "kapi", "kapi": kapi.duplicate(true), "kamera": kamera.duplicate(true),
		"diyalog_onbellek": o._gemini.duplicate(true)}
	if not slot.yaz(veri):
		return {"ok": false, "neden": "Geçici kayıt yazılamadı; önceki kayıt noktası korunuyor."}
	return {"ok": true, "gun": o.gun}

func oku(katalog: Katalog) -> Dictionary:
	var veri := slot.oku()
	var meta: Variant = veri.get("debug_snapshot")
	if not meta is Dictionary or meta.get("surum") != 1 or meta.get("faz") not in ["koy", "kapi"] or not meta.get("kamera") is Dictionary or not meta.get("diyalog_onbellek") is Array:
		return {"ok": false, "neden": "Geçerli köy kayıt noktası bulunamadı."}
	# Oturum.kayittan geçersiz sürüm için engine hatası basar; önce sessiz doğrula.
	var goc: Dictionary = preload("res://src/sistemler/kayit_gocu.gd").uygula(veri, katalog.koy_ayarlari.mevsim_gun)
	if goc.is_empty():
		return {"ok": false, "neden": "Kayıt noktası sürümü/verisi geçersiz."}
	var o := Oturum.kayittan(katalog, goc)
	if o == null or o.yonetim.son != "":
		return {"ok": false, "neden": "Kayıt noktası canlı bir köy içermiyor."}
	o._gemini.assign(meta["diyalog_onbellek"])
	var kapi := {}
	if meta["faz"] == "kapi":
		if not meta.get("kapi") is Dictionary: return {"ok": false, "neden": "Kapı snapshot verisi geçersiz."}
		kapi = KapiAnlikGoruntusu.yukle(meta["kapi"], katalog)
		if kapi.is_empty(): return {"ok": false, "neden": "Kapı snapshot verisi geçersiz."}
	return {"ok": true, "oturum": o, "kapi": kapi, "kamera": meta["kamera"].duplicate(true), "yedekten": veri.get("_yedekten", false)}

static func alinabilir(ana: Node) -> bool:
	if not is_instance_valid(ana) or ana.get("_ust") != null or ana.get("_kapi_yukleniyor"): return false
	if ZamanMakinesi.uygun(ana): return true
	return NpcCagirma.uygun(ana) and ana.get("_ekran").get("_gelen") != null and not ana.get("_ekran").has_node("ChrInceleme")

static func donulebilir(ana: Node) -> bool:
	if not is_instance_valid(ana) or ana.get("katalog") == null or ana.get("kayit") == null or ana.get("_ust") != null or ana.get("_kapi_yukleniyor"):
		return false
	if alinabilir(ana):
		return true
	var e: Node = ana.get("_ekran")
	return is_instance_valid(e) and e.get_script() != null and e.get_script().get_global_name() in ["MenuEkrani", "BilgiEkrani"]

func yakala(ana: Node) -> Dictionary:
	if not alinabilir(ana):
		return {"ok": false, "neden": "Köy/kapı sorgusu gerekli; rapor/olay/inceleme/geçiş önce tamamlanmalı."}
	if NpcCagirma.uygun(ana):
		return al(ana.get("oturum"), {}, KapiAnlikGoruntusu.kaydet(ana.get("_ekran")))
	var s: Node = ana.get("_ekran").get("sahne3b")
	var h: Vector3 = s.get("hedef")
	return al(ana.get("oturum"), {"hedef": [h.x, h.y, h.z], "yon": s.get("yon"), "egim": s.get("egim"), "uzaklik": s.get("uzaklik")})

func geri_don(ana: Node) -> Dictionary:
	if not donulebilir(ana):
		return {"ok": false, "neden": "Rapor/olay/animasyon kapanmadan geri dönülemez."}
	var sonuc := oku(ana.get("katalog"))
	if not sonuc["ok"]:
		return sonuc
	var o: Oturum = sonuc["oturum"]
	# Normal slot yazılamıyorsa canlı modeli/ekranı değiştirme.
	if not ana.get("kayit").yaz(o.kaydet()):
		return {"ok": false, "neden": "Normal kayıt yazılamadı; mevcut oturum korunuyor."}
	Engine.time_scale = 1.0
	ana.set("oturum", o)
	if not sonuc["kapi"].is_empty():
		await ana.call("_kapiya_git", sonuc["kapi"])
		return {"ok": true, "gun": o.gun, "yedekten": sonuc["yedekten"]}
	ana.call("_koye_git")
	var s: Node = ana.get("_ekran").get("sahne3b")
	var k: Dictionary = sonuc["kamera"]
	var h: Variant = k.get("hedef")
	if h is Array and h.size() == 3 and h.all(func(x: Variant) -> bool: return (x is int or x is float) and is_finite(float(x))):
		s.set("hedef", Vector3(h[0], h[1], h[2]))
	for alan in ["yon", "egim", "uzaklik"]:
		var deger: Variant = k.get(alan)
		if (deger is int or deger is float) and is_finite(float(deger)):
			s.set(alan, float(deger))
	s.call("_kamera_yerlestir")
	return {"ok": true, "gun": o.gun, "yedekten": sonuc["yedekten"]}
