## KRI-14: erzak tükenince kışla nöbetçileri ambara yönelir. KRI-06 kıtlık isyanının açık
## yüzeyine (durum().kitlik_gece_sayisi + o gecenin kitlik_isyani olayı) bağlanır; ikinci
## kıtlık/yağma motoru değildir. RNG yok; gün kilidi mevcut KRI-06 makbuzunda saklanır.
extends RefCounted

static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/kitlik_nobeti.json"))

## Bu gece nöbette olan etkin muhafızlar (KoyYonetimi.etkin_muhafiz_sayisi ile aynı koşul).
static func nobetciler(y: KoyYonetimi) -> Array[Koylu]:
	var r: Array[Koylu] = []
	for k in y.koylular:
		if KarantinaYoneticisi.aktif(k): continue
		if not KervanKorumasi.disarida(y, k.id) and MuhafizMaasi.aday(k, y) and not MuhafizMaasi.borclu(k, y) and k.yas_grubu == &"yetiskin" and not IsKazalari.uyuyor(k) and not IsMemnuniyeti.isyanci(k, y): r.append(k)
	return r

## _isyan'dan hemen sonra. İlk kıtlık gecesi uyarı; yağma gecesi nöbetçi varsa arbede.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	if y.son != &"": return
	var nob := nobetciler(y)
	if nob.is_empty(): return
	var yagma_olayi: Dictionary = {}
	for e in olaylar:
		if e.has("kitlik_isyani") and int(e.kitlik_isyani.gece) == y.gun: yagma_olayi = e
	if yagma_olayi.is_empty():
		var d := KitlikIsyani.durum(y)
		if int(d.son_gece) == y.gun and int(d.kitlik_gece_sayisi) == 1 and not d.tetiklendi:
			if not preload("res://src/koy/kitlik_nobet_makbuzu.gd").al(y): return
			olaylar.append({"anahtar": "kitlik_nobeti", "kitlik_nobeti": {"tur": "uyari", "nobetci": nob.size()}})
		return
	if not preload("res://src/koy/kitlik_nobet_makbuzu.gd").al(y, yagma_olayi): return
	var oran := minf(1.0, nob.size() * float(AYAR.nobetci_basina_geri_alma))
	var geri := {}
	var yagma: Dictionary = yagma_olayi.kitlik_isyani.yagma
	for tur in yagma:
		var adet := y.kaynaklar.ekle(tur, floori(int(yagma[tur]) * oran))
		if adet > 0: geri[tur] = adet
	for k in y.koylular:
		if not KervanKorumasi.disarida(y, k.id): k.moral = maxi(0, k.moral - int(AYAR.arbede_koy_moral))
	for k in nob: k.moral = maxi(0, k.moral - int(AYAR.arbede_nobetci_moral))
	olaylar.append({"anahtar": "kitlik_nobeti", "kitlik_nobeti": {"tur": "arbede", "nobetci": nob.size(), "geri": geri, "koy_moral": int(AYAR.arbede_koy_moral), "nobetci_moral": int(AYAR.arbede_nobetci_moral)}})

static func olay_metin(e: Dictionary) -> String:
	var d: Dictionary = e.kitlik_nobeti
	if d.tur == "uyari":
		return "Kıtlık nöbeti · erzak tükendi; %d nöbetçi kışladan ambar kapısına yöneldi. Erzak gelmezse yarın gece halkla arbede çıkar." % d.nobetci
	var parca: Array[String] = []
	for tur in d.geri: parca.append("%d %s" % [d.geri[tur], tur])
	return "Ambarda arbede · %d nöbetçi yağmacılarla çatıştı%s. Köyün morali −%d, nöbetçilerin −%d daha." % [d.nobetci, ("; geri alınan: " + ", ".join(parca)) if not parca.is_empty() else "; geri alınacak mal kalmadı", d.koy_moral, d.nobetci_moral]
