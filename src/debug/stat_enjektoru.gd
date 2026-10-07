## ADM-04: mevcut modelin görünümü; ikinci bir stat gerçeği yaratmaz.
class_name StatEnjektoru
extends RefCounted

const ALANLAR := ["Refah", "Erzak", "Guvenlik", "Moral", "Saglik"]

static func oku(o: Oturum, alan: String) -> int:
	match alan:
		"Refah": return o.koy_akce
		"Erzak": return o.ambar
		"Guvenlik": return 100 - o.yonetim.asayis_riski
		"Moral", "Saglik":
			if o.yonetim.koylular.is_empty():
				return 100
			var toplam := 0
			for k in o.yonetim.koylular:
				toplam += k.moral if alan == "Moral" else k.saglik
			return toplam / o.yonetim.koylular.size()
	return 0

static func degistir(o: Oturum, alan: String, fark: int) -> Dictionary:
	if o == null or o.yonetim.son != "" or alan not in ALANLAR or absi(fark) > KaynakEnjektoru.SINIR:
		return {"ok": false, "neden": "Canlı oturum ve geçerli stat/miktar gerekli."}
	if alan in ["Refah", "Erzak"]:
		var r := KaynakEnjektoru.degistir(o, "koy_akce" if alan == "Refah" else "gida", fark)
		r["alan"] = alan
		return r
	if alan in ["Moral", "Saglik"] and o.yonetim.koylular.is_empty():
		return {"ok": false, "neden": "Moral/Sağlık düzenlemek için köylü gerekli; boş köye değer yazılmaz."}
	var once := oku(o, alan)
	if alan == "Guvenlik":
		o.yonetim.asayis_riski = clampi(o.yonetim.asayis_riski - fark, 0, 100)
	else:
		for k in o.yonetim.koylular:
			if alan == "Moral":
				k.moral = clampi(k.moral + fark, 0, 100)
			else:
				k.saglik = clampi(k.saglik + fark, 0, 100)
	var sonra := oku(o, alan)
	o._koy_esitle()
	return {"ok": true, "alan": alan, "once": once, "sonra": sonra, "fark": sonra - once}
