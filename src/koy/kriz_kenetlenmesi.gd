## KRI-10: mevcut krizlerin kapanışı; ikinci kriz/Refah motoru değildir.
## Global sınıf veya autoload tipi yok; gece ve kayıt ince preload adaptörleri.
extends RefCounted

const META := &"kriz_kenetlenmesi"
const TURLER := ["isyan", "salgin", "kuyu", "yas"]
const AD := {"isyan": "İsyan/kıtlık", "salgin": "Salgın", "kuyu": "Kirli kuyu", "yas": "Köy yası"}
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/kriz_kenetlenmesi.json"))

static func _tam(v: Variant, alt: int) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and floor(float(v)) == float(v) and float(v) >= alt and float(v) <= 1000000000

## Optional dönem makbuzu. Kayıt yükleme/HUD okuma bonus ya da kriz yaratmaz.
static func oku(v: Variant) -> Dictionary:
	var bos := {"son_gece": -1, "baslangic": -1, "turler": [], "son_bonus": -1}
	if not v is Dictionary or not v.get("turler") is Array: return bos
	for alan in ["son_gece", "baslangic", "son_bonus"]:
		if not _tam(v.get(alan), -1): return bos
	var turler: Array[String] = []
	for tur in v.turler:
		if tur not in TURLER or tur in turler: return bos
		turler.append(tur)
	if (v.baslangic == -1) != turler.is_empty() or v.son_bonus > v.son_gece or (v.baslangic >= 0 and v.son_bonus >= v.baslangic): return bos
	# Legacy kayıt ileri günde ilk kez gözlenebilir; gün bağı yukle'de sınanır.
	return {"son_gece": int(v.son_gece), "baslangic": int(v.baslangic), "turler": turler, "son_bonus": int(v.son_bonus)}

## Salt okunur; aynı modeldeki optional kayıt makbuzunu verir.
static func durum(y: KoyYonetimi) -> Dictionary:
	return oku(y.get_meta(META, {}))

## Gelecek tarihli/bozuk makbuz ve legacy kayıt güvenli, ödül uygulanmaz.
static func yukle(y: KoyYonetimi, v: Variant) -> void:
	var d := oku(v)
	if maxi(int(d.son_gece), int(d.baslangic)) > y.gun: d = oku({})
	y.set_meta(META, d)

## Yerel yaşayan halk; karantina/çocuk/yaşlı dahil, zindan/dış görev hariç.
static func yerel(y: KoyYonetimi, k: Koylu) -> bool:
	return k.saglik > 0 and not DivanHukmu.zindanda(k) and not KervanKorumasi.disarida(y, k.id)

## Yalnız açık belirtiler dönem başlatır; gizli kuluçka kimseyi ifşa etmez.
static func krizler(y: KoyYonetimi) -> Array[String]:
	var r: Array[String] = []
	if y.isyan_kalan >= 0: r.append("isyan")
	for k in y.koylular:
		if yerel(y, k) and SaglikYoneticisi.hasta(k) and "hasta" in k.bayraklar:
			r.append("salgin")
			break
	if KuyuKirliligi.kirli(y): r.append("kuyu")
	var yas := CenazeYasi.durum(y)
	if not yas.is_empty() and y.gun <= int(yas.bitis): r.append("yas")
	return r

static func _izle(y: KoyYonetimi, d: Dictionary) -> void:
	for tur in krizler(y):
		if int(d.baslangic) < 0: d.baslangic = y.gun
		if tur not in d.turler: d.turler.append(tur)

## Gece başı fotoğrafı: bu gecede iyileşen son hasta/isyan da gözlemlenir.
static func baslat(y: KoyYonetimi) -> void:
	var d := durum(y)
	if y.son != "" or y.gun <= int(d.son_gece): return
	_izle(y, d)
	y.set_meta(META, d)

static func _iyilesmis(y: KoyYonetimi) -> bool:
	if not krizler(y).is_empty() or y.kaynaklar.miktar("gida") <= 0 or FisiltiGazetesi.HISTERI.bekliyor(y): return false
	var halk := 0
	for k in y.koylular:
		if not yerel(y, k): continue
		halk += 1
		# Yeni gizli enfeksiyon çözülmeden salgın bitti ilan edilmez.
		# Kişi/neden rapora taşınmaz; yalnız toplu iyileşme kapısıdır.
		if k.ac or SaglikYoneticisi.hasta(k): return false
	return halk > 0

## Gece sonu, terminal denetimden sonra: dönem başına bir tavanlı bonus.
## Örtüşen krizler, açlık/karantina ve yükleme ikinci ödül üretmez; RNG yok.
static func bitir(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	var d := durum(y)
	if y.son != "" or y.gun <= int(d.son_gece): return
	_izle(y, d)
	d.son_gece = y.gun
	if int(d.baslangic) >= 0 and _iyilesmis(y):
		var turler: Array = d.turler.duplicate()
		d.baslangic = -1
		d.turler = []
		# Beklemede kapanan yeni kriz ertelenmiş/üst üste bonus saklamaz.
		if int(d.son_bonus) < 0 or y.gun - int(d.son_bonus) >= int(AYAR.bekleme_gun):
			var sadakat := 0
			var refah := 0
			var kisi := 0
			for k in y.koylular:
				if not yerel(y, k): continue
				var s := clampi(k.sadakat + int(AYAR.sadakat), 0, 100)
				var r := clampi(k.refah + int(AYAR.refah), int(EkonomikRefah.AYAR.alt), int(EkonomikRefah.AYAR.ust))
				sadakat += s - k.sadakat
				refah += r - k.refah
				k.sadakat = s
				k.refah = r
				kisi += 1
			d.son_bonus = y.gun
			olaylar.append({"anahtar": "kriz_kenetlenmesi", "kriz_kenetlenmesi": {"turler": turler, "kisi": kisi, "sadakat": sadakat, "refah": refah, "sadakat_tavan": int(AYAR.sadakat), "refah_tavan": int(AYAR.refah)}})
	y.set_meta(META, d)

## Mevcut gece raporunda gerçek toplam kazanım; gizli hasta/kimlik listesi yok.
static func olay_metin(e: Dictionary) -> String:
	var d: Dictionary = e.kriz_kenetlenmesi
	var adlar: Array[String] = []
	for tur in d.turler: adlar.append(AD[tur])
	return "Toplumsal kenetlenme · %s atlatıldı. %d yerel köylüye Sadakat +%d ve Refah +%d (kişi başına tavan); gerçek toplam kazanım Sadakat +%d, Refah +%d. Örtüşen krizler tek dönem sayılır." % [", ".join(adlar), d.kisi, d.sadakat_tavan, d.refah_tavan, d.sadakat, d.refah]
