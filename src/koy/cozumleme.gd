## YAP-05: ilk veri/oda dilimi. İş/kuyruk/gece adaptörü sonraki dilimdedir.
extends RefCounted
const DEFTERLER = preload("res://src/koy/usta_defterleri.gd")
static func dogrula(veri: Variant = null) -> PackedStringArray:
	var d: Variant = DEFTERLER.AYAR if veri == null else veri
	var hatalar := DEFTERLER.dogrula(d)
	if not hatalar.is_empty(): return hatalar
	var ayar: Variant = d.get("cozumleme")
	if not ayar is Dictionary or ayar.get("oda_turu") != "cozumleme_odasi" or ayar.get("mevsim_carpani") != "insa_carpani" or not DEFTERLER.tam(ayar.get("kamu_bedel")):
		hatalar.append("Çözümleme odası/tek bedel/mevsim kaynağı bozuk")
	for id in d.defterler:
		var arastirma: Variant = d.defterler[id].get("arastirma")
		if not arastirma is Dictionary or not DEFTERLER.tam(arastirma.get("sure_gun")) or int(arastirma.get("sure_gun",0)) <= 0:
			hatalar.append("Pozitif tam çözümleme süresi gerekli: " + String(id))
			continue
		var sonuc: Variant = arastirma.get("sonuc")
		if not sonuc is Dictionary or sonuc.size() != 2 or sonuc.get("hedef_sistem") != "hizarhane_uretimi":
			hatalar.append("Tek mevcut hedef gerekli: " + String(id))
			continue
		var carpan: Variant = sonuc.get("carpan")
		if not (carpan is int or carpan is float) or not is_finite(float(carpan)) or float(carpan) <= 0:
			hatalar.append("Pozitif sonlu sonuç çarpanı gerekli: " + String(id))
	return hatalar

static func oda(y: KoyYonetimi, id: int) -> bool:
	var b := y.bina(id)
	return b != null and b.hazir() and b.tur == String(DEFTERLER.AYAR.cozumleme.oda_turu)
