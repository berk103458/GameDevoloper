## Bozuk/eksik runtime alanları için kaynak değiştirmeyen okuma sınırı.
extends RefCounted

static func metin(deger: Variant, varsayilan: String = "") -> String:
	return String(deger) if deger is String or deger is StringName else varsayilan

static func sozluk(deger: Variant) -> Dictionary:
	return deger.duplicate(true) if deger is Dictionary else {}

static func dugum(deger: Variant) -> Dictionary:
	var sonuc := sozluk(deger)
	sonuc["replik_anahtari"] = metin(sonuc.get("replik_anahtari"))
	var secenekler := []
	var kaynak: Variant = sonuc.get("secenekler")
	if kaynak is Array:
		for secenek in kaynak:
			if not secenek is Dictionary:
				continue
			var s: Dictionary = secenek.duplicate(true)
			s["metin_anahtari"] = metin(s.get("metin_anahtari"))
			s["hedef"] = metin(s.get("hedef"))
			s["beceri"] = metin(s.get("beceri"))
			s["tansiyon_delta"] = s.get("tansiyon_delta", 0) if s.get("tansiyon_delta", 0) is int else 0
			for alan in ["gerekli_ipuclari", "gerekli_bayraklar"]:
				var liste := []
				var adaylar: Variant = s.get(alan, [])
				if adaylar is Array:
					for aday in adaylar:
						if aday is String or aday is StringName:
							liste.append(aday)
				s[alan] = liste
			secenekler.append(s)
	sonuc["secenekler"] = secenekler
	var bayraklar := []
	var kaynak_bayraklar: Variant = sonuc.get("bayraklar", [])
	if kaynak_bayraklar is Array:
		for bayrak in kaynak_bayraklar:
			if metin(bayrak) in ChrSozlesmesi.BAYRAKLAR:
				bayraklar.append(metin(bayrak))
	sonuc["bayraklar"] = bayraklar
	var gecisler := []
	var kaynak_gecisler: Variant = sonuc.get("gecisler", [])
	if kaynak_gecisler is Array:
		for gecis in kaynak_gecisler:
			if not gecis is Dictionary or metin(gecis.get("hedef")).is_empty():
				continue
			var kosul := sozluk(gecis.get("tansiyon_kosulu"))
			if not metin(kosul.get("operator")) in [">=", "<"] or not kosul.get("deger") is int:
				continue
			gecisler.append({"hedef": metin(gecis["hedef"]), "tansiyon_kosulu": kosul})
	sonuc["gecisler"] = gecisler
	return sonuc
