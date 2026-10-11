## BUG-17: yalnız mevcut bina ve köylü kayıtlarını okur; ikinci kişi/yer listesi tutmaz.
extends RefCounted

static func kisi_uygun(y: KoyYonetimi, kisi: Koylu) -> bool:
	return kisi != null and y.koylu(kisi.id) == kisi and kisi.saglik > 0 and kisi.yas_grubu != &"cocuk" and not DivanHukmu.zindanda(kisi) and not KervanKorumasi.disarida(y, kisi.id)

static func sec(y: KoyYonetimi) -> String:
	var adaylar: Array[KoyBinasi] = []
	for b in y.binalar:
		if b.hazir() and y.katalog.turler.has(b.tur): adaylar.append(b)
	if adaylar.is_empty(): return ""
	adaylar.sort_custom(func(a: KoyBinasi, b: KoyBinasi) -> bool: return a.id < b.id)
	var s := int(y.gun / maxi(1, int(FisiltiGazetesi.AYAR.aralik_gece)))
	var ad := MeslekYapilari.ad(adaylar[s % adaylar.size()].tur)
	if GuvenliMetin.anahtar_gibi_mi(ad): ad = GuvenliMetin.metin(ad)
	return ad.to_lower()
