## OMR-03: Uygun adlı adaylara Perde 1 nüfus döneminin rol payını uygular.
extends RefCounted

static func rol(k: KarakterVerisi) -> String:
	match k.sinif:
		&"asker": return "asker"
		&"esnaf":
			return "tuccar" if k.zanaat_turu in [ZanaatTuru.Tur.ESNAF, ZanaatTuru.Tur.BELIRSIZ] else "zanaat"
		_: return "koylu"

static func agirliklar(o: Oturum, ids: Array[StringName]) -> Array[float]:
	var taban := GuvenlikKafileDengesi.adli_agirliklar(o, ids)
	var paylar: Dictionary = Omurga.sinif_agirliklari().get(Omurga.donem(o.yonetim), {})
	if o.perde != 1 or paylar.is_empty(): return taban
	var roller := PackedStringArray()
	var toplamlar := {}
	for i in ids.size():
		var tur := rol(o.katalog.karakter(ids[i]))
		roller.append(tur)
		toplamlar[tur] = float(toplamlar.get(tur, 0.0)) + taban[i]
	var sonuc: Array[float] = []
	for i in ids.size():
		var tur := roller[i]
		var toplam := float(toplamlar[tur])
		sonuc.append(float(paylar.get(tur, 0.0)) * taban[i] / toplam if toplam > 0.0 else 0.0)
	# Adayı olmayan rolün payı asker veya tehdide aktarılmaz.
	var bos_pay := 0.0
	for tur in paylar:
		if float(toplamlar.get(tur, 0.0)) <= 0.0: bos_pay += float(paylar[tur])
	if bos_pay > 0.0: sonuc.append(bos_pay)
	return sonuc

static func adli_indeks(o: Oturum, ids: Array[StringName]) -> int:
	var indeks := GuvenlikKafileDengesi.sec(o._rng, agirliklar(o, ids))
	return indeks if indeks < ids.size() else -1
