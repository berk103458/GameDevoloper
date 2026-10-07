## Debug kese işlemleri karar uygulamaz; kamu ve kişisel kasa ayrı kalır.
class_name KasaDenetleyici
extends RefCounted
const SINIR := 1000000

static func degistir(o: Oturum, islem: String, miktar: int = 0) -> Dictionary:
	if o == null or o.yonetim.son != "" or islem not in ["koy_akce", "muhafiz_akce", "kese_ekle", "kese_sifirla"] or miktar < 0 or miktar > SINIR or (islem == "kese_ekle" and miktar == 0):
		return {"ok": false, "neden": "Canlı oturum, geçerli işlem ve 0–1.000.000 akçe gerekli (ekleme >0)."}
	var once := {"koy": o.koy_akce, "muhafiz": o.muhafiz_akce, "esya": o.muhafiz_esyalari.size()}
	match islem:
		"koy_akce": o.koy_akce = miktar
		"muhafiz_akce": o.muhafiz_akce = miktar
		"kese_ekle":
			if o.muhafiz_akce > 9223372036854775807 - miktar:
				return {"ok": false, "neden": "Kese toplamı sayısal sınırı aşıyor."}
			o.muhafiz_akce += miktar
		"kese_sifirla":
			o.muhafiz_akce = 0
			o.muhafiz_esyalari.clear()
	o._koy_esitle()
	return {"ok": true, "islem": islem, "once": once,
		"sonra": {"koy": o.koy_akce, "muhafiz": o.muhafiz_akce, "esya": o.muhafiz_esyalari.size()}}

static func uygula(ana: Node, islem: String, miktar: int = 0) -> Dictionary:
	if not DurumAnlikGoruntusu.alinabilir(ana):
		return {"ok": false, "neden": "Kararlı köy/kapı gerekli; açık rapor/olay/heybe/geçiş önce tamamlanmalı."}
	var r := degistir(ana.get("oturum"), islem, miktar)
	if r["ok"]:
		var ekran: Node = ana.get("_ekran")
		if ZamanMakinesi.uygun(ana): ekran.call("_yenile")
		else: ekran.get("hud").call("guncelle")
		r["kaydedildi"] = ana.get("kayit").yaz(ana.get("oturum").kaydet())
	return r
