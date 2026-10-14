## ADM-09: canlı köyde tekrarlanabilir stres girdileri, gerçek gece raporları.
class_name SenaryoKosucusu
extends RefCounted
const KIMLIKLER := ["kitlik_10", "baskin", "veba"]
const TEHDIT = preload("res://src/sistemler/tehdit_takvimi.gd")

static func calistir(o: Oturum, id: String, tohum: int = 0) -> Dictionary:
	if o != null and preload("res://src/sistemler/kapi_acilis_olayi.gd").gece_engelli(o): return {"ok": false, "neden": "İlk ailenin kararı bekleniyor."}
	if o == null or id not in KIMLIKLER or o.yonetim.son != "" or o.yonetim.koylular.is_empty():
		return {"ok": false, "neden": "Canlı, nüfuslu köy ve tanımlı senaryo gerekli."}
	var y := o.yonetim
	if y.has_meta(GeceDeneyi.META):
		return {"ok": false, "neden": "Başka gece deneyi aktif; senaryo üstüne yazılmadı."}
	var ayarlar := y.a
	var hazirlik := {}
	var kayiplar: Array[Dictionary] = []
	match id:
		"kitlik_10":
			# Üretim gerçekten hesaplanır; sonra gıda kaybı ve gerçek açlık/tüketim.
			y.set_meta(GeceDeneyi.META, func(koy: KoyYonetimi) -> void:
				var kayip := koy.kaynaklar.azalt("gida", koy.kaynaklar.miktar("gida"))
				kayiplar.append({"gun": koy.gun, "gida_kaybi": kayip})
			)
		"baskin":
			# Yalnız bu gece gerçek Husumet zarı kesin baskın verir; kaynak ayarlar korunur.
			y.set_meta(TEHDIT.DEBUG_BASKIN, true)
			y.a = ayarlar.duplicate(true)
			y.a.baskin_zar = 1.0 + y.muhafiz_sayisi() * y.a.muhafiz_zar_indirimi
			y.husumet.puan = maxi(y.husumet.puan, y.a.baskin_esigi + y.a.husumet_sonum)
			hazirlik["husumet"] = y.husumet.puan
		"veba":
			# Eski stres hasarı korunur; sonraki gerçek geceler tek KRI-01 motorunda.
			for k in y.koylular:
				SaglikYoneticisi.enfekte(y, k, "veba")
				k.bayrak_ac("hasta")
				k.saglik = maxi(0, k.saglik - 40)
			hazirlik["hasta_koylu"] = y.koylular.size()
	var sonuc := ZamanMakinesi.ilerlet(o, 10 if id == "kitlik_10" else 1, tohum)
	# Terminal sonuç/bekleyen olay dahil tüm normal dönüşlerde deney ve ayar geri alınır.
	if y.has_meta(GeceDeneyi.META):
		y.remove_meta(GeceDeneyi.META)
	if id == "baskin": y.remove_meta(TEHDIT.DEBUG_BASKIN)
	y.a = ayarlar
	sonuc["senaryo"] = id
	sonuc["hazirlik"] = hazirlik
	sonuc["kayiplar"] = kayiplar
	return sonuc

static func uygula(ana: Node, id: String) -> Dictionary:
	if not ZamanMakinesi.uygun(ana):
		return {"ok": false, "neden": "Hazır köy gerekli; rapor/olay sırasında senaryo çalışmaz."}
	var sonuc := calistir(ana.get("oturum"), id)
	if not sonuc["ok"]:
		return sonuc
	ana.get("_ekran").call("_hiz_sec", 1)
	if sonuc["son"] != "":
		ana.call("_son_goster", StringName(sonuc["son"]))
	else:
		ana.call("_koye_git")
		if sonuc["bekleyen_olay"] != null:
			var ekran: Node = ana.get("_ekran")
			ekran.get("_gece_kilidi").al()
			ekran.get("_gece_dugmesi").disabled = true
			ekran.call("_olay_goster", sonuc["bekleyen_olay"], sonuc["gece"])
	return sonuc
