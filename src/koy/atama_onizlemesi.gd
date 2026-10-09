## UZM-15: hipotetik atama yalnız izole model kopyasında; canlı RNG/stok/atama değişmez.
class_name AtamaOnizlemesi
extends RefCounted
static func oku(y: KoyYonetimi, kisi: int, hedef: int) -> Dictionary:
	var k := y.koylu(kisi)
	var b := y.bina(hedef)
	var r := {"olur": false, "neden": "Kişi veya bina bulunamadı", "once": {}, "sonra": {}, "fark": {}, "uyum": 0.0, "sinergi": 1.0, "yesil": false}
	if k == null or b == null: return r
	for s in KoyluKartiVerisi.secenekler(y, k):
		if s.id == hedef:
			r.neden = s.neden
			break
	if y.katalog.slot(b.tur) <= 0: r.neden = "Bu yapıda iş yuvası yok"
	if not r.neden.is_empty(): return r
	var yeni := KoyYonetimi.kayittan(y.a, y.katalog, y.kaydet().duplicate(true))
	if not yeni.ata(kisi, hedef):
		r.neden = "Atama koşulları değişti"
		return r
	r.olur = true
	var aday := yeni.koylu(kisi)
	var bina := yeni.bina(hedef)
	r.uyum = MeslekUyumu.carpan(aday, bina.tur)
	r.sinergi = YasRolleri.carpan(yeni, bina)
	r.once = brut(y, b)
	r.sonra = brut(yeni, bina)
	for tur in r.sonra: r.fark[tur] = float(r.sonra[tur]) - float(r.once.get(tur, 0.0))
	for tur in r.once:
		if not r.fark.has(tur): r.fark[tur] = -float(r.once[tur])
	if y.isyan_kalan >= 0: r.neden = "Köy isyanı: üretim durmuş"
	elif KanDavasi.engel(yeni, hedef): r.neden = "Kan davası: üretim durmuş"
	elif MeslekGrevi.aktif(aday, yeni): r.neden = "Grev: üretimi reddeder"
	elif ZanaatKazalari.durur(aday): r.neden = "Kaza: geçici üretim duruşu"
	elif IsMemnuniyeti.isyanci(aday, yeni): r.neden = "Kişisel iş reddi"
	elif yeni.kis_mi() and bool(y.katalog.veri(b.tur).get("kis_durur", false)): r.neden = "Kış: üretim durmuş"
	elif not y.kaynaklar.yeterli(y.katalog.receteler(b.tur).get(b.recete, {}).get("girdi", {})): r.neden = "Girdi eksik"
	elif b.tur not in ["sifahane", "muhafiz_kislasi"] and y.kaynaklar.toplam() >= y.kaynaklar.kapasite: r.neden = "Ambar dolu"
	if b.tur == "sifahane":
		r.once = {"tedavi": float(Sifahane.tedavi_kapasitesi(y, b.id))}
		r.sonra = {"tedavi": float(Sifahane.tedavi_kapasitesi(yeni, b.id))}
		r.fark = {"tedavi": r.sonra.tedavi - r.once.tedavi}
	elif b.tur == "muhafiz_kislasi":
		r.once = {"nobet": float(y.etkin_muhafiz_sayisi())}
		r.sonra = {"nobet": float(yeni.etkin_muhafiz_sayisi())}
		r.fark = {"nobet": r.sonra.nobet - r.once.nobet}
		if MuhafizMaasi.borclu(aday, yeni): r.neden = "Maaş borcu: ödeme yapılana kadar etkin nöbet yok"
	var artis := false
	for tur in r.fark:
		if float(r.fark[tur]) > 0: artis = true
	r.yesil = r.neden.is_empty() and (r.uyum >= 1.0 or YasRolleri.danisman(aday, bina.tur)) and artis
	return r
static func brut(y: KoyYonetimi, b: KoyBinasi) -> Dictionary:
	var r := {}
	if not b.hazir() or y.isyan_kalan >= 0 or KanDavasi.engel(y, b.id): return r
	var v := y.katalog.veri(b.tur)
	if y.kis_mi() and bool(v.get("kis_durur", false)): return r
	var recete: Dictionary = y.katalog.receteler(b.tur).get(b.recete, {})
	if not y.kaynaklar.yeterli(recete.get("girdi", {})) or y.kaynaklar.toplam() >= y.kaynaklar.kapasite: return r
	for k in y.calisanlar(b.id):
		if KarantinaYoneticisi.aktif(k): continue
		if not YasRolleri.fiziksel(k, b.tur) or IsMemnuniyeti.isyanci(k, y) or ZanaatKazalari.durur(k): continue
		var c := Uretim.koylu_carpani(k, String(v.get("uzmanlik", "")), y.a, b.tur) * YasRolleri.carpan(y, b) * DemirZinciri.carpan(y, b.tur)
		for tur in recete.get("uretim", {}):
			r[tur] = float(r.get(tur, 0.0)) + Uretim.gunluk(float(recete.uretim[tur]), k.stat, c) * b.uretim_carpani()
	return r
static func metin(r: Dictionary) -> String:
	var satirlar: Array[String] = ["Uyum ×%.2f · danışman sinerjisi ×%.2f" % [r.uyum, r.sinergi]]
	for tur in r.sonra: satirlar.append("%s: %.2f → %.2f (bina farkı %+.2f)" % [tur, r.once.get(tur, 0.0), r.sonra[tur], r.fark.get(tur, 0.0)])
	if not r.neden.is_empty(): satirlar.append(r.neden)
	satirlar.append("Brüt tahmin; net gece sonucu stok ve olaylara bağlıdır.")
	return "\n".join(satirlar)
