## ADM-08 inşaat adaptörü: gerçek bina listesi, kapasite ve barınma APIleri.
class_name BinaManipulatoru
extends RefCounted

static func insaatlari_bitir(o: Oturum) -> Dictionary:
	if o == null or o.yonetim.son != "":
		return {"ok": false, "neden": "Canlı köy oturumu gerekli."}
	var tamamlanan: Array[int] = []
	for b in o.yonetim.binalar:
		if b.insa_kalan > 0:
			b.insa_kalan = 0
			tamamlanan.append(b.id)
	o.yonetim._ambar_kapasitesi()
	o.yonetim._barindir()
	o._koy_esitle()
	return {"ok": true, "tamamlanan": tamamlanan}

static func seviye_artir(o: Oturum, id: int) -> Dictionary:
	if o == null or o.yonetim.son != "":
		return {"ok": false, "neden": "Canlı köy gerekli."}
	var y := o.yonetim
	if id == -1:
		if y.sur_seviye >= y.a.sur_bedel.size():
			return {"ok": false, "neden": "Sur son tanımlı seviyede."}
		y.sur_seviye += 1
		y.sur_taksit_odenen = 0
		return {"ok": true, "mesaj": "Sur seviyesi %d; hasar %d%%." % [y.sur_seviye, y.sur_hasar]}
	var b := y.bina(id)
	if b == null or not b.hazir():
		return {"ok": false, "neden": "Tamamlanmış bir bina seç."}
	b.seviye += 1
	y._ambar_kapasitesi()
	y._barindir()
	o._koy_esitle()
	return {"ok": true, "mesaj": "Bina #%d seviye %d · üretim ×%.2f · yatak %d · depo %d." % [b.id, b.seviye, b.uretim_carpani(), b.yatak(y.katalog), b.depo_kapasitesi(y.katalog)]}

static func sur_durumu(o: Oturum, hasar: int) -> Dictionary:
	if o == null or o.yonetim.son != "" or hasar not in [0, 50, 100] or o.yonetim.sur_seviye <= 0:
		return {"ok": false, "neden": "Kurulu sur ve sağlam/hasarlı/yanmış durum gerekli."}
	o.yonetim.sur_hasar = hasar
	return {"ok": true, "mesaj": "Sur hasarı %d%% · toplam savunma %d." % [hasar, o.yonetim.savunma_gucu()]}

static func uygula(ana: Node, eylem: String = "bitir", id: int = -1) -> Dictionary:
	if not ZamanMakinesi.uygun(ana):
		return {"ok": false, "neden": "Hazır köy gerekli; gece raporu/olay açıkken inşaat tamamlanamaz."}
	var sonuc: Dictionary
	var o: Oturum = ana.get("oturum")
	match eylem:
		"bitir": sonuc = insaatlari_bitir(o)
		"seviye": sonuc = seviye_artir(o, id)
		"saglam": sonuc = sur_durumu(o, 0)
		"hasarli": sonuc = sur_durumu(o, 50)
		"yanmis": sonuc = sur_durumu(o, 100)
		_: return {"ok": false, "neden": "Bilinmeyen bina eylemi."}
	if sonuc["ok"]:
		ana.get("_ekran").call("_yenile")
		sonuc["kaydedildi"] = ana.get("kayit").yaz(ana.get("oturum").kaydet())
	return sonuc
