## YAP-01: yapı türü kademesi ADM-08 bina seviyesinden ayrıdır.
## Bilgiyi yaşayan kişilerden okur; sorgular kademe veya para yazmaz.
class_name YapiKilidi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/yapi_kademeleri.json"))

static func kademe(tur: String) -> int:
	return int(AYAR.binalar.get(tur, 0))

static func gereken_bilgi(tur: String) -> String:
	return tur if kademe(tur) > 0 else ""

static func sur_kademesi(hedef_seviye: int) -> int:
	return int(AYAR.sur[hedef_seviye - 1]) if hedef_seviye >= 1 and hedef_seviye <= AYAR.sur.size() else 0

static func eksik_turler(katalog: BinaKatalogu) -> PackedStringArray:
	var sonuc := PackedStringArray()
	for tur in katalog.turler:
		if katalog.veri(tur).get("kurulabilir", true) and not AYAR.binalar.has(tur): sonuc.append(tur)
	sonuc.sort()
	return sonuc

static func dogrula(katalog: BinaKatalogu, veri: Variant = null) -> PackedStringArray:
	var d: Variant = AYAR if veri == null else veri
	var hatalar := PackedStringArray()
	if not d is Dictionary or not d.get("binalar") is Dictionary:
		return PackedStringArray(["binalar: kademe tablosu gerekli"])
	for tur in d.binalar:
		var k: Variant = d.binalar[tur]
		if not katalog.var_mi(String(tur)): hatalar.append("Bilinmeyen bina kimliği: " + String(tur))
		if not (k is int or k is float) or not is_finite(float(k)) or float(k) != floor(float(k)) or float(k) < 0 or float(k) > 3:
			hatalar.append("K0–K3 dışında kademe: " + String(tur))
	var sur: Variant = d.get("sur")
	if not sur is Array or sur.size() != 3:
		hatalar.append("Sur kademeleri mevcut üç seviye ile eşleşmeli")
	else:
		for i in 3:
			var s: Variant = sur[i]
			if not (s is int or s is float) or not is_finite(float(s)) or float(s) != float(i + 1):
				hatalar.append("Sur kademeleri mevcut üç seviye ile eşleşmeli")
	var carpanlar: Variant = d.get("insa_mevsim_carpanlari")
	if not carpanlar is Array or carpanlar.size() != 4:
		hatalar.append("Dört mevcut mevsim için inşaat çarpanı gerekli")
	else:
		for c in carpanlar:
			if not (c is int or c is float) or not is_finite(float(c)) or float(c) <= 0 or float(c) > 1:
				hatalar.append("Geçersiz mevsim inşaat çarpanı")
	return hatalar


## Tek optional kişi alanı; eski/bozuk kayıt bilgi açmaz.
static func bilgi_oku(v: Variant) -> PackedStringArray:
	var sonuc := PackedStringArray()
	if not v is Array and not v is PackedStringArray: return sonuc
	for tur in v:
		if (tur is String or tur is StringName) and AYAR.binalar.has(String(tur)) and kademe(String(tur)) > 0 and not String(tur) in sonuc:
			sonuc.append(String(tur))
	sonuc.sort()
	return sonuc

static func kurulu_kademe(y: KoyYonetimi, id: int) -> int:
	var b := y.bina(id)
	return kademe(b.tur) if b != null and b.hazir() else 0

static func durum(y: KoyYonetimi, tur: String) -> Dictionary:
	var k := kademe(tur)
	var d := {"kademe": k, "acik": true, "neden": "", "bilgi": gereken_bilgi(tur)}
	if k == 0: return d
	var bilgi_var := false
	for kisi in y.koylular:
		if kisi.saglik > 0 and tur in kisi.yapi_bilgisi:
			bilgi_var = true
			break
	if not bilgi_var:
		d.acik = false
		d.neden = "yapi_bilgisi"
		return d
	if k >= 2:
		var on_kademe := false
		for b in y.binalar:
			if b.hazir() and kademe(b.tur) == k - 1:
				on_kademe = true
				break
		if not on_kademe:
			d.acik = false
			d.neden = "yapi_on_kademe"
	return d

static func metin(y: KoyYonetimi, tur: String) -> String:
	var d := durum(y, tur)
	if d.acik: return ""
	if d.neden == "yapi_on_kademe":
		return TranslationServer.translate("koy.yapi_kilidi.on_kademe") % (int(d.kademe) - 1)
	return TranslationServer.translate("koy.yapi_kilidi.gerekli") % MeslekYapilari.ad(tur)
