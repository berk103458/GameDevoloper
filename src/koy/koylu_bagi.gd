class_name KoyluBagi
extends RefCounted
## SEV-05: UZM-07 toplumsal bağının dostluk ucu.
## Dost çift aynı binada çalışırken data/soz/koylu_bagi.json içindeki farkı verime ekler
## ve ateşte tek bir cümle duyulmasını sağlar; yalnız iki taraf da köyde ise.

const VERI_YOLU := "res://data/soz/koylu_bagi.json"
const UCLAR := ["dost", "dusman"]
const YASAK_ALANLAR := ["kalp", "romans", "hediye", "hediye_istegi"]

static var _onbellek: Dictionary = {}


static func _ayar() -> Dictionary:
	if _onbellek.is_empty() and FileAccess.file_exists(VERI_YOLU):
		var metin := FileAccess.get_file_as_string(VERI_YOLU)
		var veri: Variant = JSON.parse_string(metin)
		if veri is Dictionary:
			_onbellek = veri
	return _onbellek


static func dost_verim_farki() -> float:
	return maxf(0.0, float(_ayar().get("dost_verim_farki", 0.0)))


static func normalize_uc(v: Variant) -> String:
	var s := String(v).strip_edges().to_lower()
	if s == "dost" or s == "dostluk":
		return "dost"
	if s == "dusman" or s == "dusmanlik":
		return "dusman"
	return ""


static func _cift_anahtar(a: int, b: int) -> Array[int]:
	var out: Array[int] = [mini(a, b), maxi(a, b)]
	return out


static func _yasak_alani_var(d: Dictionary) -> bool:
	for k in YASAK_ALANLAR:
		if d.has(k):
			return true
	return false


static func oku(v: Variant) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	if not v is Array:
		return sonuc
	var gorulen: Dictionary = {}
	for oge in v:
		if not oge is Dictionary:
			continue
		if _yasak_alani_var(oge):
			continue
		var kisiler: Variant = oge.get("kisiler")
		if not kisiler is Array or kisiler.size() != 2:
			continue
		var a := int(kisiler[0])
		var b := int(kisiler[1])
		if a <= 0 or b <= 0 or a == b:
			continue
		var uc := normalize_uc(oge.get("uc", ""))
		if not uc in UCLAR:
			continue
		var cift := _cift_anahtar(a, b)
		var anahtar := "%d:%d" % [cift[0], cift[1]]
		if gorulen.has(anahtar):
			continue
		gorulen[anahtar] = true
		sonuc.append({
			"kisiler": cift,
			"uc": uc,
			"gun": maxi(0, int(oge.get("gun", 0))),
		})
	return sonuc


static func koyde_mi(y: KoyYonetimi, k: Koylu) -> bool:
	if y == null or k == null or y.koylu(k.id) != k:
		return false
	return (
		k.saglik > 0
		and not KarantinaYoneticisi.aktif(k)
		and not DivanHukmu.zindanda(k)
		and not KervanKorumasi.disarida(y, k.id)
	)


static func cift_bag_ucu(y: KoyYonetimi, a_id: int, b_id: int) -> String:
	if y == null or a_id <= 0 or b_id <= 0 or a_id == b_id:
		return ""
	var cift := _cift_anahtar(a_id, b_id)
	for b in y.baglar:
		if not b is Dictionary:
			continue
		var k: Variant = b.get("kisiler", [])
		if k is Array and k.size() == 2 and int(k[0]) == cift[0] and int(k[1]) == cift[1]:
			return normalize_uc(b.get("uc", ""))
	var ka := y.koylu(a_id)
	var kb := y.koylu(b_id)
	if ka != null and kb != null and KanDavasi.dusman(ka, kb):
		return "dusman"
	return ""


static func bugun_bag_kuruldu_mu(y: KoyYonetimi) -> bool:
	if y == null:
		return false
	for b in y.baglar:
		if b is Dictionary and int(b.get("gun", -1)) == y.gun:
			return true
	return false


static func kur(y: KoyYonetimi, a_id: int, b_id: int, uc: String = "dost") -> bool:
	if y == null or a_id <= 0 or b_id <= 0 or a_id == b_id:
		return false
	var temiz_uc := normalize_uc(uc)
	if temiz_uc.is_empty():
		return false
	if bugun_bag_kuruldu_mu(y):
		return false
	var ka := y.koylu(a_id)
	var kb := y.koylu(b_id)
	if not koyde_mi(y, ka) or not koyde_mi(y, kb):
		return false
	if temiz_uc == "dost" and KanDavasi.dusman(ka, kb):
		return false
	var cift := _cift_anahtar(a_id, b_id)
	for b in y.baglar:
		if not b is Dictionary:
			continue
		var kisiler: Variant = b.get("kisiler", [])
		if kisiler is Array and kisiler.size() == 2 and int(kisiler[0]) == cift[0] and int(kisiler[1]) == cift[1]:
			return false
	y.baglar.append({
		"kisiler": cift,
		"uc": temiz_uc,
		"gun": maxi(0, y.gun),
	})
	return true


static func gun_sonu_kur(y: KoyYonetimi) -> bool:
	if y == null or bugun_bag_kuruldu_mu(y):
		return false
	for b in y.binalar:
		if b == null or not b.hazir():
			continue
		var isciler := y.calisanlar(b.id)
		if isciler.size() < 2:
			continue
		for i in range(isciler.size()):
			var ka := isciler[i]
			if not koyde_mi(y, ka) or ka.yas_grubu == &"cocuk":
				continue
			for j in range(i + 1, isciler.size()):
				var kb := isciler[j]
				if not koyde_mi(y, kb) or kb.yas_grubu == &"cocuk":
					continue
				if KanDavasi.dusman(ka, kb):
					continue
				if cift_bag_ucu(y, ka.id, kb.id) != "":
					continue
				if kur(y, ka.id, kb.id, "dost"):
					return true
	return false


static func verim_farki(y: KoyYonetimi, k: Koylu, bina_id: int) -> float:
	if y == null or k == null or bina_id < 0 or y.baglar.is_empty():
		return 0.0
	if not koyde_mi(y, k):
		return 0.0
	var fark := dost_verim_farki()
	if fark <= 0.0:
		return 0.0
	for diger in y.calisanlar(bina_id):
		if diger == null or diger.id == k.id:
			continue
		if not koyde_mi(y, diger):
			continue
		if KanDavasi.dusman(k, diger):
			continue
		if cift_bag_ucu(y, k.id, diger.id) == "dost":
			return fark
	return 0.0


static func ates_satiri(y: KoyYonetimi, adaylar: Array = []) -> String:
	if y == null or y.baglar.is_empty():
		return ""
	var aday_idler: Dictionary = {}
	for a in adaylar:
		if a is Koylu:
			aday_idler[a.id] = true
		elif a is int:
			aday_idler[int(a)] = true
	for b in y.baglar:
		if not b is Dictionary or normalize_uc(b.get("uc", "")) != "dost":
			continue
		var kisiler: Variant = b.get("kisiler", [])
		if not kisiler is Array or kisiler.size() != 2:
			continue
		var k1 := y.koylu(int(kisiler[0]))
		var k2 := y.koylu(int(kisiler[1]))
		if not koyde_mi(y, k1) or not koyde_mi(y, k2) or KanDavasi.dusman(k1, k2):
			continue
		if not aday_idler.is_empty() and not (aday_idler.has(k1.id) or aday_idler.has(k2.id)):
			continue
		return String(_ayar().get("ates_satiri", ""))
	return ""


static func kart_kelimesi(y: KoyYonetimi, k: Koylu) -> String:
	if y == null or k == null or not koyde_mi(y, k):
		return ""
	for b in y.baglar:
		if not b is Dictionary:
			continue
		var kisiler: Variant = b.get("kisiler", [])
		if not kisiler is Array or kisiler.size() != 2:
			continue
		var a := int(kisiler[0])
		var c := int(kisiler[1])
		if a != k.id and c != k.id:
			continue
		var diger_id := c if a == k.id else a
		var diger := y.koylu(diger_id)
		if not koyde_mi(y, diger):
			continue
		var uc := normalize_uc(b.get("uc", ""))
		if uc == "dost":
			return String(TranslationServer.translate(String(_ayar().get("kart_kelimesi_dost", ""))))
		if uc == "dusman":
			return String(TranslationServer.translate(String(_ayar().get("kart_kelimesi_dusman", ""))))
	for diger in y.koylular:
		if diger != null and diger.id != k.id and koyde_mi(y, diger) and KanDavasi.dusman(k, diger):
			return String(TranslationServer.translate(String(_ayar().get("kart_kelimesi_dusman", ""))))
	return ""


static func uzm07_uc(k: Koylu, y: KoyYonetimi = null) -> String:
	if k == null:
		return ""
	var dusmanlar: Variant = k.toplumsal_bag.get("dusman_gruplar", [])
	if dusmanlar is Array and not dusmanlar.is_empty():
		return "dusman"
	if y != null:
		for b in y.baglar:
			if not b is Dictionary:
				continue
			var kisiler: Variant = b.get("kisiler", [])
			if kisiler is Array and (k.id in kisiler):
				return normalize_uc(b.get("uc", ""))
	return ""
