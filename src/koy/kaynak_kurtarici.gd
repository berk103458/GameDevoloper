## BUG-21: kurulmamış ocak ile gerçekten kurulamayan ocağı ayırır.
class_name KaynakKurtarici
extends RefCounted

static func ocak_kurulabilir(y: KoyYonetimi) -> bool:
	if not y.katalog.var_mi("tas_ocagi") or not y.katalog.veri("tas_ocagi").get("kurulabilir", true): return false
	var m := y.katalog.maliyet("tas_ocagi")
	if not y.kaynaklar.yeterli(y._malzeme(m)) or y.akce < int(m.get("akce", 0)): return false
	for cy in y.izgara.boyut.y:
		for cx in y.izgara.boyut.x:
			for yon in 4:
				if y.yerlesim("tas_ocagi", Vector2i(cx, cy), yon).olur: return true
	return false

static func sabah(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	var t := y.tas_yatagi
	if t == null or y.son != "" or t.son_sabah == y.gun: return
	t.son_sabah = y.gun
	if t.kalan > 0 or y.kaynaklar.miktar("tas") > 0 or t.kurtarici_sayisi >= int(TasYatagi.AYAR.kurtarici_azami): return
	for b in y.binalar:
		if b.tur == "tas_ocagi": return # İnşa halindeki ocak da vardır.
	if ocak_kurulabilir(y): return
	if not t.yerlestir(y, int(TasYatagi.AYAR.kurtarici_tas)): return
	t.kurtarici_sayisi += 1
	olaylar.append({"anahtar": "koy.tas_yatagi.kurtarici", "deger": [t.kalan]})
