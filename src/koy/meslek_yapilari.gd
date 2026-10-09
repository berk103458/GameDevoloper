## UZM-03: iki gerçek üretim türü; eski katalog değişmez.
class_name MeslekYapilari
extends RefCounted
static func ekler(temel: Dictionary) -> Dictionary:
	var ek := {}
	for cift in [["bostan", "tarla", "bostanci"], ["demirhane", "atolye", "demirci"]]:
		if not temel.has(cift[1]): continue
		var veri: Dictionary = temel[cift[1]].duplicate(true)
		veri["uzmanlik"] = cift[2]
		veri["kurulabilir"] = true
		ek[cift[0]] = veri
	return ek
static func ad(tur: String) -> String:
	if tur==GozcuKulesi.TUR: return String(GozcuKulesi.AYAR.ad)
	if tur == "muhafiz_kislasi": return "Muhafız Kışlası"
	if tur == "ahir": return "Ahır"
	return {"bostan": "Bostan", "demirhane": "Demirhane", "degirmen": "Değirmen", "sifahane": "Şifahane"}.get(tur, DemirZinciri.ad("koy.yapi." + tur))
static func aciklama(tur: String) -> String:
	if tur == "sifahane": return "Cerrah/otacı başına ortak gecelik bir tedavi. Yetkin hekim bulaşıcı hastalık sağlık kaybını %80 azaltır; ilaç tedaviyi güçlendirir. İlaç: 1 afyon + 1 su."
	if tur==GozcuKulesi.TUR: return String(GozcuKulesi.AYAR.aciklama)
	if tur == "muhafiz_kislasi": return "Nöbetçileri barındırır; kişi başı gece 1 kamu akçesi. Ödenmezse görev bırakma, asayiş ve rüşvet riski."
	if tur == "ahir": return "İki çeki hayvanı barındırır; tomruk sefer yükü üç kat, süresi yarıdır."
	return {"bostan": "Bostancıların gıda yetiştirmesinde uzmanlaştığı üretim alanı.", "demirhane": "Demirci ve dökümcülerin alet üretip işlediği ocak.", "sifahane": "Cerrah veya otacı başına gecede bir ocak yanığı tedavisi; hasta başına 2 erzak.", "degirmen": "Ham erzakı işleyen değirmen. Sağlıklı yaşlı danışman binaya %15 verim sağlar; danışman ayrıca üretim yapmaz."}.get(tur, DemirZinciri.ad("koy.yapi.%s_aciklama" % tur))
