## Oyuncu kartı: yalnız açık bilgi ve gerçek atama API'leri.
class_name KoyluKartiVerisi
extends RefCounted
static func secenekler(y: KoyYonetimi, k: Koylu) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	for b in y.binalar:
		if y.katalog.slot(b.tur) <= 0: continue
		var neden := ""
		if not b.hazir(): neden = "İnşaat tamamlanmadı"
		elif not YasRolleri.atanabilir(k, b.tur): neden = "Yaş grubu uygun değil"
		elif b.tur == "muhafiz_kislasi" and not MuhafizMaasi.aday(k, y) and y.muhafiz_sayisi() >= y.a.muhafiz_azami: neden = "Muhafız sınırı dolu"
		elif k.is_yeri != b.id and y.calisanlar(b.id).size() >= y.katalog.slot(b.tur): neden = "İş yuvaları dolu"
		var uyum := MeslekUyumu.carpan(k, b.tur)
		var danisman := YasRolleri.danisman(k, b.tur)
		sonuc.append({"id": b.id, "ad": bina_adi(b.tur), "uyum": uyum, "neden": neden, "danisman": danisman, "grev": MeslekGrevi.aday(k, b.tur)})
	sonuc.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		if a.neden.is_empty() != b.neden.is_empty(): return a.neden.is_empty()
		if a.uyum != b.uyum: return a.uyum > b.uyum
		return a.id < b.id)
	return sonuc
static func ata(y: KoyYonetimi, kisi: int, hedef: int) -> bool:
	if y.koylu(kisi) == null: return false
	if hedef == KoyYonetimi.BOSTA:
		y.bosalt(kisi)
		return true
	if hedef == KoyYonetimi.MUHAFIZ: return y.muhafiz_ata(kisi)
	return y.ata(kisi, hedef)
static func ozet(y: KoyYonetimi, k: Koylu) -> String:
	var acik: Array[String] = []
	for f in k.bayraklar: acik.append(TranslationServer.translate("koy.bayrak." + f))
	return "%s · beceri %d/10\nMoral %d · Sağlık %d · Sadakat %d · Refah %d/100\nKöye geliş: %d. gün · Köyde %d gün\nGüçlü yön: %s\nZayıf yön: %s\n%s\n%s\nAçık bilgiler: %s\n%s" % [ZanaatTuru.ad(k.zanaat_turu), k.stat, k.moral, k.saglik, k.sadakat, k.refah, k.giris_gunu + 1, maxi(0, y.gun - k.giris_gunu), PasifOzellikler.metin(k.pasif_ozellikler, true), PasifOzellikler.metin(k.pasif_ozellikler, false), YasRolleri.metin(k, y), CirakEgitimi.metin(k), ", ".join(acik) if not acik.is_empty() else "Henüz yok", GizliEgilimler.oyuncu_metin(k)]
static func uygun_turler(k: Koylu) -> String:
	var adlar: Array[String] = []
	for tur in MeslekUyumu.UYGUN.get(k.zanaat_turu, []):
		if YasRolleri.atanabilir(k, tur): adlar.append(bina_adi(tur))
	if k.adli_id == &"chr_003":
		for tur in ["demirhane", "atolye"]:
			if not bina_adi(tur) in adlar: adlar.append(bina_adi(tur))
	return ", ".join(adlar) if not adlar.is_empty() else "Özel uzmanlık eşleşmesi yok; yaş ve kapasite kuralları geçerli."

static func bina_adi(tur: String) -> String:
	var ad := MeslekYapilari.ad(tur)
	if not ad.begins_with("koy.yapi."): return ad
	for kaynak_ad in preload("res://src/koy/chr_bina_sozlugu.gd").ADLAR:
		if preload("res://src/koy/chr_bina_sozlugu.gd").ADLAR[kaynak_ad] is String and preload("res://src/koy/chr_bina_sozlugu.gd").ADLAR[kaynak_ad] == tur: return kaynak_ad.capitalize()
	return tur.replace("_", " ").capitalize()
