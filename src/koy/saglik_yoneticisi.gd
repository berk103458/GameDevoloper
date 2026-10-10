## KRI-01: tek köylü sağlığına bağlı bulaşma; Şifahane/ölüm/RNG yolu ortaktır.
class_name SaglikYoneticisi
extends RefCounted
const META := &"salgin_son_gece"
static var AYAR: Dictionary = {"veba": {"sure": 6, "risk": 30, "kayip": 12}, "humma": {"sure": 4, "risk": 20, "kayip": 8}, "tifo": {"sure": 5, "risk": 25, "kayip": 10}}
const AZAMI_TEMAS := 3
const AZAMI_YENI := 2

## Optional, JSON güvenli; bilinmeyen/bozuk kayıt hastalık üretmez.
static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary or v.get("tur") not in AYAR or not v.get("hasta_sahibi") is bool: return {}
	for alan in ["bitis", "son_gece", "hasar_gecesi"]:
		var n: Variant = v.get(alan)
		if (not n is int and not n is float) or not is_finite(float(n)) or float(n) != floor(float(n)) or float(n) < (-1 if alan != "bitis" else 0) or float(n) > 1000000000: return {}
	if v.bitis <= v.son_gece or v.bitis - v.son_gece > int(AYAR[v.tur].sure) + 1 or v.hasar_gecesi > v.son_gece: return {}
	return {"tur": String(v.tur), "bitis": int(v.bitis), "son_gece": int(v.son_gece), "hasar_gecesi": int(v.hasar_gecesi), "hasta_sahibi": v.hasta_sahibi}

static func hasta(k: Koylu) -> bool:
	return not k.enfeksiyon.is_empty()

## Gelen bayrakları mevcut kabul sözleşmesiyle taşınır. Heybe/portre/CHR'de ayrı
## güvenilir hastalık alanı yok; hikâye metni veya hekimin sargısı kanıt değildir.
static func kabul(y: KoyYonetimi, k: Koylu) -> void:
	var bayraklar := k.bayraklar + k.gizli_bayraklar
	var tur := ""
	if "veba" in bayraklar: tur = "veba"
	elif "humma" in bayraklar: tur = "humma"
	elif "hasta" in bayraklar and k.adli_id != &"chr_002": tur = "humma"
	if tur.is_empty(): return
	if enfekte(y, k, tur): k.enfeksiyon.hasta_sahibi = true

## KRI-02/03 için tek API; süre üst üste eklenmez, RNG çekmez.
static func enfekte(y: KoyYonetimi, k: Koylu, tur: String = "humma") -> bool:
	if y.son != &"" or k == null or k.saglik <= 0 or hasta(k) or tur not in AYAR: return false
	var sahip := "hasta" not in k.bayraklar + k.gizli_bayraklar
	k.enfeksiyon = {"tur": tur, "bitis": y.gun + int(AYAR[tur].sure), "son_gece": y.gun - 1, "hasar_gecesi": -1, "hasta_sahibi": sahip}
	if sahip: k.gizli_bayraklar.append("hasta")
	return true

## Karantina ve dış görev dahil iki yönde bulaşmanın tek temas kapısı.
static func temas_edebilir(y: KoyYonetimi, k: Koylu) -> bool:
	return k.saglik > 0 and not KarantinaYoneticisi.aktif(k) and not DivanHukmu.zindanda(k) and not KervanKorumasi.disarida(y, k.id)

static func ortak_bina(y: KoyYonetimi, a: Koylu, b: Koylu) -> bool:
	for id in [a.ev, a.is_yeri]:
		if id < 0 or id not in [b.ev, b.is_yeri]: continue
		var bina := y.bina(id)
		if bina != null and bina.hazir(): return true
	return false

## Başlangıç fotoğrafı: yeni hasta aynı gecede zincirleme kaynak olamaz.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> int:
	if y.son != &"" or KisHastaligi.gece_oku(y.get_meta(META, -1)) == y.gun: return 0
	var kaynaklar: Array[Koylu] = []
	for k in y.koylular:
		if not hasta(k): continue
		if y.gun >= int(k.enfeksiyon.bitis):
			iyilestir(k)
			continue
		k.enfeksiyon.son_gece = y.gun
		if not temas_edebilir(y, k): continue
		k.bayrak_ac("hasta")
		if k.enfeksiyon.tur == "tifo": continue # Yalnız kirli kuyu suyu; temas bulaşması yok.
		kaynaklar.append(k)
	if kaynaklar.is_empty(): return 0
	y.set_meta(META, y.gun)
	kaynaklar.sort_custom(func(a: Koylu, b: Koylu) -> bool: return a.id < b.id)
	var kisiler := y.koylular.duplicate()
	kisiler.sort_custom(func(a: Koylu, b: Koylu) -> bool: return a.id < b.id)
	var denenen := {}
	var yeni := 0
	for kaynak in kaynaklar:
		var temas := 0
		for aday in kisiler:
			if yeni >= AZAMI_YENI or temas >= AZAMI_TEMAS: break
			if aday == kaynak or hasta(aday) or denenen.has(aday.id) or not temas_edebilir(y, aday) or not (ortak_bina(y, kaynak, aday) or CenazeYasi.ortak_toren(y, kaynak, aday)): continue
			denenen[aday.id] = true
			temas += 1
			if y._rng.randi_range(1, 100) > KoyYonetimi.ACLIK_SAGLIK.risk(y, int(AYAR[kaynak.enfeksiyon.tur].risk)): continue
			if enfekte(y, aday, String(kaynak.enfeksiyon.tur)):
				aday.enfeksiyon.son_gece = y.gun
				aday.bayrak_ac("hasta")
				yeni += 1
	if yeni > 0: olaylar.append({"anahtar": "Köyde %d yeni hastalık belirtisi görüldü; Şifahane tedavisi bekleniyor.", "deger": [yeni]})
	return yeni # KRI-04 aynı gecenin iki vaka sınırından kalan yeri kullanır.

## Ev iyileşmesinden sonra, mevcut tek ölüm kontrolünden önce çağrılır.
static func saglik_kaybi(y: KoyYonetimi, k: Koylu) -> void:
	if not hasta(k) or int(k.enfeksiyon.son_gece) != y.gun or int(k.enfeksiyon.hasar_gecesi) == y.gun or KervanKorumasi.disarida(y, k.id): return
	k.enfeksiyon.hasar_gecesi = y.gun
	k.saglik -= HekimIlac.hastalik_kaybi(y, int(AYAR[k.enfeksiyon.tur].kayip))

## Yanık/kış tedavisinden kalan gerçek kontenjan; ikinci Şifahane yok.
static func tedavi(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	for k in KoyYonetimi.SIFAHANE_TRIYAJ.sira(y): # KRI-13 triyaj: en ağır hasta önce
		if not hasta(k) or not temas_edebilir(y, k): continue
		var bedel := HekimIlac.tedavi_bedeli(y)
		if Sifahane.tedavi_kapasitesi(y) <= 0 or not y.kaynaklar.harca(bedel): break
		SifahaneKontenjani.kullan(y)
		k.saglik = mini(100, k.saglik + (HekimIlac.ILAC_SAGLIK if bedel.has("ilac") else 10))
		iyilestir(k)
		olaylar.append({"anahtar": "Şifahane %s hastalığını tedavi etti; 1 ilaç kullanıldı (+25 sağlık)." if bedel.has("ilac") else "Şifahane %s hastalığını tedavi etti; 2 erzak kullanıldı.", "deger": [k.ad]})

static func iyilestir(k: Koylu) -> void:
	if not hasta(k): return
	if k.enfeksiyon.hasta_sahibi:
		k.bayraklar.erase("hasta")
		k.gizli_bayraklar.erase("hasta")
	k.enfeksiyon.clear()

## Köylü kartı satırı; belirti açılmadan (gizli kuluçka) hastalık ifşa edilmez.
static func metin(k: Koylu, y: KoyYonetimi) -> String:
	if not hasta(k) or "hasta" not in k.bayraklar: return ""
	var ad: String = {"veba": "Veba", "humma": "Humma", "tifo": "Tifo"}.get(k.enfeksiyon.tur, "Hastalık")
	var yol := "su kaynaklı · kişiler arasında bulaşmaz" if k.enfeksiyon.tur == "tifo" else "bulaşıcı"
	return "%s belirtisi: en geç %d gün · %s · Şifahane boş kontenjanı %d" % [ad, maxi(0, int(k.enfeksiyon.bitis) - y.gun), "karantinada temas engelli · " + yol if KarantinaYoneticisi.aktif(k) else yol, Sifahane.tedavi_kapasitesi(y)]
