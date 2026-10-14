## Debug gece simülasyonu: üretim/tüketim ve olaylar gerçek Oturum API'sinden.
class_name ZamanMakinesi
extends RefCounted

static func ilerlet(o: Oturum, adet: int, tohum: int = 0) -> Dictionary:
	if o != null and preload("res://src/sistemler/kapi_acilis_olayi.gd").gece_engelli(o): return {"ok": false, "neden": "İlk ailenin kararı bekleniyor."}
	if o == null or adet not in [1, 5, 10] or o.yonetim.son != "":
		return {"ok": false, "neden": "Canlı oturum ve 1/5/10 günlük adım gerekli."}
	var rng := RandomNumberGenerator.new()
	if tohum == 0:
		rng.randomize()
	else:
		rng.seed = tohum
	var sonuc := {"ok": true, "istenen": adet, "gecen": 0, "baslangic_gun": o.gun,
		"gun": o.gun, "raporlar": [], "son": "", "bekleyen_olay": null, "gece": {}}
	for i in adet:
		var gece := o.gece_sonu()
		sonuc["gece"] = gece
		sonuc["gecen"] += 1
		sonuc["gun"] = o.gun
		sonuc["son"] = String(gece["son"])
		var kayit := {"rapor": gece["rapor"].duplicate(true), "olay_id": "", "secenek": -1, "mini_oyun_puan": -1}
		var olay: OlayVerisi = gece.get("olay")
		if olay != null:
			kayit["olay_id"] = String(olay.id)
			var uygunlar: Array[int] = []
			for secenek in olay.secenek_etkileri.size():
				if o.secenek_olur(olay, secenek):
					uygunlar.append(secenek)
			if uygunlar.is_empty():
				sonuc["bekleyen_olay"] = olay
			else:
				var secenek := uygunlar[rng.randi_range(0, uygunlar.size() - 1)]
				# Debug batch mini oyunu oynayamaz; ödül/başarı uydurmak yerine sıfır puan.
				var puan := 0 if olay.secenek_etkileri[secenek].has("oyun") else -1
				kayit["secenek"] = secenek
				kayit["mini_oyun_puan"] = puan
				kayit["olay_sonucu"] = o.olay_uygula(olay, secenek, puan)
		sonuc["raporlar"].append(kayit)
		if sonuc["son"] != "" or sonuc["bekleyen_olay"] != null:
			break
	return sonuc

static func uygun(ana: Node) -> bool:
	if not is_instance_valid(ana) or ana.get("oturum") == null:
		return false
	if preload("res://src/sistemler/kapi_acilis_olayi.gd").gece_engelli(ana.get("oturum")): return false
	var ekran: Node = ana.get("_ekran")
	if not is_instance_valid(ekran) or ekran.get_script() == null or ekran.get_script().get_global_name() != "KoyEkrani":
		return false
	return ekran.get("_ust_kart") == null and ekran.get("mini_oyun") == null and ana.get("oturum").yonetim.son == ""

static func uygula(ana: Node, adet: int) -> Dictionary:
	if not uygun(ana) or adet not in [1, 5, 10]:
		return {"ok": false, "neden": "Köy yönetimi gerekli; açık gece raporu/olay önce tamamlanmalı."}
	ana.get("_ekran").call("_hiz_sec", 1)
	var sonuc := ilerlet(ana.get("oturum"), adet)
	if not sonuc["ok"]:
		return sonuc
	if sonuc["son"] != "":
		ana.call("_son_goster", StringName(sonuc["son"]))
	else:
		# Eski ekranın gece kilidi/rapor callbackleriyle yeni günü karıştırma.
		ana.call("_koye_git")
		if sonuc["bekleyen_olay"] != null:
			var ekran: Node = ana.get("_ekran")
			ekran.get("_gece_kilidi").al()
			ekran.get("_gece_dugmesi").disabled = true
			ekran.call("_olay_goster", sonuc["bekleyen_olay"], sonuc["gece"])
	return sonuc
