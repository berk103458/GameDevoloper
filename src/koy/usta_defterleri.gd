## YAP-04: kişisel eşya sözlüğü; yapı bilgisini veya ekonomik zarları yazmaz.
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/usta_defterleri.json"))
static func tam(v: Variant) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= 0 and float(v) <= 1000000
static func dogrula(veri: Variant = null) -> PackedStringArray:
	var d: Variant = AYAR if veri == null else veri
	var hatalar := PackedStringArray()
	if not d is Dictionary or not d.get("defterler") is Dictionary or not d.get("ganimet") is Dictionary: return PackedStringArray(["Defter ve ganimet tabloları gerekli"])
	for id in d.defterler:
		var v: Variant = d.defterler[id]
		if not v is Dictionary or not v.get("ad") is String or String(v.ad).is_empty() or not v.get("yapi") is String or not YapiKilidi.AYAR.binalar.has(v.yapi) or not tam(v.get("deger")):
			hatalar.append("Bozuk defter: " + String(id))
	for kaynak in d.ganimet:
		var satir: Variant = d.ganimet[kaynak]
		if not satir is Dictionary or satir.is_empty():
			hatalar.append("Boş ganimet: " + String(kaynak))
			continue
		var toplam := 0
		for id in satir:
			if (id != "yok" and not d.defterler.has(id)) or not tam(satir[id]): hatalar.append("Bozuk ganimet satırı: " + String(kaynak))
			else: toplam += int(satir[id])
		if toplam <= 0 or toplam > 1000000: hatalar.append("Geçersiz toplam ağırlık: " + String(kaynak))
	return hatalar

## Var olan makbuz + oyun tohumu: aynı sonuç yeniden zar atmaz; RNG nesnesi yok.
static func ganimet(o: Oturum, kaynak: String, makbuz: String) -> String:
	if not o.yonetim.son.is_empty() or makbuz.is_empty() or not AYAR.ganimet.has(kaynak): return ""
	var satir: Dictionary = AYAR.ganimet[kaynak]
	var toplam := 0
	for agirlik in satir.values(): toplam += int(agirlik)
	if toplam <= 0: return ""
	var secim := int((str(o.tohum) + "|" + kaynak + "|" + makbuz).hash()) % toplam
	for id in satir:
		secim -= int(satir[id])
		if secim < 0:
			return String(id) if id != "yok" and ekle(o, String(id)) else ""
	return ""

static func ekle(o: Oturum, id: String) -> bool:
	if not AYAR.defterler.has(id): return false
	var varmis := false
	for e in o.muhafiz_esyalari:
		if e.get("id") == id and int(e.get("adet",0)) > 0: varmis = true
	if not varmis:
		var d: Dictionary = AYAR.defterler[id]
		o.muhafiz_esyalari.append({"id":id,"ad":d.ad,"tur":"esya","adet":1,"deger":int(d.deger)})
	o.muhafiz_esyalari = duzenle(o.muhafiz_esyalari)
	if not varmis: o.koy.degisti.emit()
	return not varmis

## Aynı mevcut envanterde bilinen defter kimlikleri tek kayıt/yığın1 kalır.
static func duzenle(esyalar: Array[Dictionary]) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	var gorulen := {}
	for e in esyalar:
		var id := String(e.get("id",""))
		if not AYAR.defterler.has(id):
			sonuc.append(e)
			continue
		if int(e.get("adet",0)) <= 0: continue
		if gorulen.has(id): continue
		gorulen[id] = true
		var kayit := e.duplicate(true)
		kayit.adet = 1
		sonuc.append(kayit)
	return sonuc

## Gerçek gece raporu; dış görev mevcut süresiyle döner, baskın sonucu yeniden uygulanmaz.
static func gece(o: Oturum, rapor: Dictionary) -> void:
	for id in o.yonetim.kervan_koruma:
		var gorev: Dictionary = o.yonetim.kervan_koruma[id]
		var k := o.yonetim.koylu(int(id))
		if int(gorev.donus) == o.gun and k != null and k.saglik > 0:
			ganimet(o,"sefer",str(id) + ":" + str(gorev.donus))
	var olaylar: Array = rapor.get("olaylar",[])
	for i in olaylar.size():
		if olaylar[i].get("anahtar") == "koy.olay.baskin": ganimet(o,"baskin",str(o.gun) + ":" + str(i))
