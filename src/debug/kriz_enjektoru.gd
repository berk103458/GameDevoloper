## ADM-14: debug girdileri; normal ölüm/üretim/tüketim döngüsü korunur.
class_name KrizEnjektoru
extends RefCounted
const META := &"debug_kuyu_zehri"
const ISLEMLER := ["veba", "kuyu", "kundak"]

static func kalan(y: KoyYonetimi) -> int:
	return int(y.get_meta(META)) if y.has_meta(META) else 0

static func yukle(y: KoyYonetimi, v: Variant) -> void:
	if (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and int(v) >= 1 and int(v) <= 3:
		y.set_meta(META, int(v))

static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	var n := kalan(y)
	if n == 0: return
	# TEK-07: sonraki KuyuKirliligi.gece gerçek su raporu ve köy RNG'siyle işler.
	olaylar.append({"anahtar": "Debug: Zehirli kuyu; taze su içenlerde olasılıkla tifo.", "deger": []})
	if n == 1: y.remove_meta(META)
	else: y.set_meta(META, n - 1)

static func tetikle(o: Oturum, id: String) -> Dictionary:
	if o == null or o.yonetim.son != "" or id not in ISLEMLER:
		return {"ok": false, "neden": "Canlı köy ve tanımlı kriz gerekli."}
	var y := o.yonetim
	if id in ["veba", "kuyu"] and y.koylular.is_empty():
		return {"ok": false, "neden": "Sağlık deneyi için nüfus gerekli."}
	var mesaj := ""
	var kayip := {}
	match id:
		"veba":
			for k in y.koylular:
				SaglikYoneticisi.enfekte(y, k, "veba")
				k.bayrak_ac("hasta")
				k.saglik = maxi(0, k.saglik - 40)
			mesaj = "%d köylü: hasta bayrağı, −40 sağlık. Ölüm kontrolü gerçek gece sonunda." % y.koylular.size()
		"kuyu":
			if kalan(y) > 0: return {"ok": false, "neden": "Kuyu zaten zehirli; süre üstüne eklenmedi."}
			y.set_meta(META, 3)
			KuyuKirliligi.kirlet(y)
			mesaj = "Köy suyu zehirli: sonraki 3 gece taze kuyu suyu içenlerde tifo riski %%%d. Kireçle dezenfekte edilebilir." % int(SaglikYoneticisi.AYAR.tifo.risk)
		"kundak":
			if y.kaynaklar.toplam() == 0: return {"ok": false, "neden": "Ambar boş; kundaklamanın stok hedefi yok."}
			for tur in y.kaynaklar.kaydet()["stok"]:
				kayip[tur] = y.kaynaklar.azalt(tur, ceili(y.kaynaklar.miktar(tur) * 0.5))
			mesaj = "Ambar kundaklandı; her stok türünün yarısı kaybedildi (yukarı yuvarla): %s" % kayip
	return {"ok": true, "islem": id, "mesaj": mesaj, "kayip": kayip, "kuyu_gece": kalan(y)}

static func uygula(ana: Node, id: String) -> Dictionary:
	if not ZamanMakinesi.uygun(ana) or ana.get("_ust") != null:
		return {"ok": false, "neden": "Kararlı köy gerekli; rapor/olay/geçiş önce tamamlanmalı."}
	var r := tetikle(ana.get("oturum"), id)
	if r["ok"]:
		ana.get("_ekran").call("_yenile")
		r["kaydedildi"] = ana.get("kayit").yaz(ana.get("oturum").kaydet())
	return r
