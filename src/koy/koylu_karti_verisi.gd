## Oyuncu kartı: yalnız açık bilgi ve gerçek atama API'leri.
class_name KoyluKartiVerisi
extends RefCounted
static func secenekler(y: KoyYonetimi, k: Koylu) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	for b in y.binalar:
		if y.katalog.slot(b.tur) <= 0: continue
		var neden := ""
		if KarantinaYoneticisi.aktif(k): neden = "Karantinada; atama korunuyor"
		elif not b.hazir(): neden = "İnşaat tamamlanmadı"
		elif not YasRolleri.atanabilir(k, b.tur): neden = "Yaş grubu uygun değil"
		elif b.tur == "muhafiz_kislasi" and not HaneEsi.izinli_mi(k, "kisla"): neden = "Eş kışlaya atanmaz"
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
	if KarantinaYoneticisi.aktif(y.koylu(kisi)): return false
	if hedef == KoyYonetimi.BOSTA:
		y.bosalt(kisi)
		return true
	if hedef == KoyYonetimi.MUHAFIZ: return y.muhafiz_ata(kisi)
	return y.ata(kisi, hedef)
## KAP-18: genç yaş grubuna geçince ustanın yanına ya da uygun boş işe çırak ataması.
static func cirak_atamasi(y: KoyYonetimi, k: Koylu) -> Dictionary:
	if y == null or k == null or k.yas_grubu != &"genc":
		return {"acik": false, "hedef": -1, "ad": ""}
	if KarantinaYoneticisi.aktif(k) or DivanHukmu.zindanda(k):
		return {"acik": false, "hedef": -1, "ad": ""}
	var sec := secenekler(y, k)
	var usta_bina := -1
	var ilk_bos := -1
	var ad_harita := {}
	for s in sec:
		ad_harita[int(s.id)] = String(s.ad)
		if not String(s.neden).is_empty(): continue
		if ilk_bos < 0: ilk_bos = int(s.id)
		if usta_bina < 0:
			for u in y.calisanlar(int(s.id)):
				if CirakEgitimi.usta(u):
					usta_bina = int(s.id)
					break
	var hedef := usta_bina if usta_bina >= 0 else ilk_bos
	return {"acik": true, "hedef": hedef, "ad": String(ad_harita.get(hedef, ""))}
static func ozet(y: KoyYonetimi, k: Koylu) -> String:
	var acik: Array[String] = []
	for f in k.bayraklar: acik.append("Zindanda" if f == DivanHukmu.FLAG else "Kış hastası" if f == KisHastaligi.FLAG else TranslationServer.translate("koy.bayrak." + f))
	return TranslationServer.translate("koy.kart.ozet") % [ZanaatTuru.ad(k.zanaat_turu), k.stat, k.moral, k.saglik, k.sadakat, k.refah, k.giris_gunu + 1, maxi(0, y.gun - k.giris_gunu), PasifOzellikler.metin(k.pasif_ozellikler, true), PasifOzellikler.metin(k.pasif_ozellikler, false), YasRolleri.metin(k, y), CirakEgitimi.metin(k), ", ".join(acik) if not acik.is_empty() else "Henüz yok", GizliEgilimler.oyuncu_metin(k)] + "\n" + YasamBarlari.metin(k, y)
## SOY-08: söz güvenilirliği kartta bir kelimedir (ağzı sıkı / konuşkan / uyduruyor); sayı gösterilmez.
static func soz_guvenilirligi(o: Object, k: Koylu) -> String:
	return "Sözü: " + SoylentiKoprusu.guvenilirlik_kelimesi(o, k.id)
static func uygun_turler(k: Koylu) -> String:
	var adlar: Array[String] = []
	for tur in MeslekUyumu.UYGUN.get(k.zanaat_turu, []):
		if YasRolleri.atanabilir(k, tur): adlar.append(bina_adi(tur))
	if k.adli_id == &"chr_003":
		for tur in ["demirhane", "atolye"]:
			if not bina_adi(tur) in adlar: adlar.append(bina_adi(tur))
	return ", ".join(adlar) if not adlar.is_empty() else TranslationServer.translate("koy.kart.uzmanlik_yok")

static func bina_adi(tur: String) -> String:
	var ad := MeslekYapilari.ad(tur)
	if not ad.begins_with("koy.yapi."): return ad
	for kaynak_ad in preload("res://src/koy/chr_bina_sozlugu.gd").ADLAR:
		if preload("res://src/koy/chr_bina_sozlugu.gd").ADLAR[kaynak_ad] is String and preload("res://src/koy/chr_bina_sozlugu.gd").ADLAR[kaynak_ad] == tur: return kaynak_ad.capitalize()
	return tur.replace("_", " ").capitalize()
