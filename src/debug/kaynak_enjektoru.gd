## Debug değişiklikleri gerçek kasaya/ambarda uygulanır; kapasite aşılmaz.
class_name KaynakEnjektoru
extends RefCounted

const ALANLAR := ["koy_akce", "muhafiz_akce", "gida", "odun", "tas", "demir"]
const SINIR := 1000000

static func degistir(o: Oturum, alan: String, fark: int) -> Dictionary:
	if o == null or o.yonetim.son != "" or alan not in ALANLAR or absi(fark) > SINIR:
		return {"ok": false, "neden": "Canlı oturum, geçerli kaynak ve ±1.000.000 sınırı gerekli."}
	var once: int
	var sonra: int
	if alan in ["koy_akce", "muhafiz_akce"]:
		once = int(o.get(alan))
		sonra = maxi(once + fark, 0)
		o.set(alan, sonra)
	else:
		var kaynak := o.yonetim.kaynaklar
		once = kaynak.miktar(alan)
		if fark >= 0:
			kaynak.ekle(alan, fark)
		else:
			kaynak.azalt(alan, -fark)
		sonra = kaynak.miktar(alan)
	o._koy_esitle()
	return {"ok": true, "alan": alan, "once": once, "sonra": sonra, "fark": sonra - once}

static func uygula(ana: Node, alan: String, fark: int) -> Dictionary:
	if not ZamanMakinesi.uygun(ana):
		return {"ok": false, "neden": "Kaynak düzenlemek için açık raporu/olayı kapatıp köye dön."}
	var sonuc := StatEnjektoru.degistir(ana.get("oturum"), alan, fark) if alan in StatEnjektoru.ALANLAR else degistir(ana.get("oturum"), alan, fark)
	if sonuc["ok"]:
		ana.get("_ekran").call("_yenile")
		sonuc["kaydedildi"] = ana.get("kayit").yaz(ana.get("oturum").kaydet())
	return sonuc
