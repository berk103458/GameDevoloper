## KRI-06: mevcut _isyan akışının deterministik kıtlık tetikleyicisi.
class_name KitlikIsyani
extends RefCounted

const META := &"kitlik_isyani"
const ESIK := 2
const ONARIM := {"tas": 4, "kereste": 6}
const YAGMA_TAVAN := 20
const TUR_TAVAN := 5
const MORAL_KAYBI := 8
const KORUNAN := ["gida", "bugday", "un", "su", "saman"]

static func _tam(v: Variant, alt: int, ust: int, varsayilan: int) -> int:
	if (v is int or v is float) and is_finite(float(v)) and floor(float(v)) == float(v) and float(v) >= alt and float(v) <= ust: return int(v)
	return varsayilan

## Optional/legacy JSON; yalnız doğrulanmış geçmiş, kapı hasarı bağımsız kalıcıdır.
static func oku(v: Variant) -> Dictionary:
	var d := {"kitlik_gece_sayisi": 0, "tetiklendi": false, "kapi_kirik": false, "son_gece": -1, "nobet_son_gece": -1}
	if not v is Dictionary: return d
	d.kitlik_gece_sayisi = _tam(v.get("kitlik_gece_sayisi"), 0, ESIK, 0)
	d.son_gece = _tam(v.get("son_gece"), -1, 1000000000, -1)
	d.nobet_son_gece = _tam(v.get("nobet_son_gece"), -1, 1000000000, -1)
	d.tetiklendi = v.get("tetiklendi") is bool and v.tetiklendi and d.kitlik_gece_sayisi == ESIK
	d.kapi_kirik = v.get("kapi_kirik") is bool and v.kapi_kirik
	return d

static func durum(y: KoyYonetimi) -> Dictionary:
	return oku(y.get_meta(META, {}))

static func yukle(y: KoyYonetimi, v: Variant) -> void:
	var d := oku(v)
	if int(d.son_gece) > y.gun: d = oku({})
	if int(d.nobet_son_gece) > y.gun: d.nobet_son_gece = -1
	y.set_meta(META, d)
	if y.kaynaklar.miktar("gida") > 0: erzak_geldi(y)

## Gerçek ambara ekleme anında seri sıfırlanır; onarım yerine geçmez.
static func erzak_geldi(y: KoyYonetimi) -> void:
	var d := durum(y)
	d.kitlik_gece_sayisi = 0
	d.tetiklendi = false
	y.set_meta(META, d)

## Tek Güvenlik değeri; etkin muhafızlar zaten asayiş/HAR-15 üzerinden dahildir.
static func koruma(y: KoyYonetimi) -> int:
	return maxi(0, KervanKorumasi.guvenlik(y) - (20 if durum(y).kapi_kirik else 0))

static func kapasite(y: KoyYonetimi, taban: int) -> int:
	return floori(taban * 0.8) if durum(y).kapi_kirik else taban

## _isyan içinde çağrılır. true: bu geceki mevcut isyan çözümü burada tamamlandı.
## KRI-14 için y.kitlik_tetiklendi(rapor) ve durum().kitlik_gece_sayisi açık yüzeydir.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> bool:
	var d := durum(y)
	if y.son != "": return false
	if d.son_gece == y.gun: return d.tetiklendi
	if not d.tetiklendi and int(d.son_gece) != y.gun - 1: d.kitlik_gece_sayisi = 0
	d.son_gece = y.gun
	if y.kaynaklar.miktar("gida") > 0 or y.koylular.is_empty():
		d.kitlik_gece_sayisi = 0
		d.tetiklendi = false
		y.set_meta(META, d)
		return false
	d.kitlik_gece_sayisi = mini(ESIK, int(d.kitlik_gece_sayisi) + 1)
	y.set_meta(META, d)
	if d.kitlik_gece_sayisi < ESIK or d.tetiklendi: return false
	# Hasarlı kapı bu baskında da korumayı düşürür, ayrı muhafız bonusu eklenmez.
	d.tetiklendi = true
	d.kapi_kirik = true
	y.set_meta(META, d)
	var guvenlik := koruma(y)
	var oran := 0.20 * (1.0 - guvenlik / 100.0)
	var kalan := YAGMA_TAVAN
	var yagma := {}
	for tur in Kaynaklar.TURLER:
		if tur in KORUNAN: continue
		var adet := y.kaynaklar.azalt(tur, mini(kalan, mini(TUR_TAVAN, floori(y.kaynaklar.miktar(tur) * oran))))
		if adet > 0: yagma[tur] = adet
		kalan -= adet
	# Aynı isyanın süresi yenilenmez; tetik gecesinde ekstra firar/RNG yok.
	if y.isyan_kalan < 0:
		y.isyan_kalan = y.a.isyan_gun
		olaylar.append({"anahtar": "koy.olay.isyan_basladi", "deger": [y.a.isyan_gun]})
	y._herkese_moral(-MORAL_KAYBI)
	# EKO-12 kapasite taşmasını yağmadan ayrı, aynı gece raporla.
	var tasma_once: Dictionary = y.kaynaklar.bakim.tasma.duplicate()
	y._ambar_kapasitesi()
	var tasma := {}
	for tur in y.kaynaklar.bakim.tasma:
		var fark := int(y.kaynaklar.bakim.tasma[tur]) - int(tasma_once.get(tur, 0))
		if fark > 0:
			tasma[tur] = fark
			olaylar.append({"anahtar": "koy.olay.ambar_ziyan", "deger": ["tasma", tur, fark]})
	# Aynı kaybın sonraki gece bir daha raporlanmasını engelle.
	y.kaynaklar.bakim.tasma = tasma_once
	var e := {"anahtar": "kitlik_isyani", "kitlik_isyani": {"gece": y.gun, "yagma": yagma, "kapasite_ziyani": tasma, "guvenlik": guvenlik, "moral": MORAL_KAYBI}}
	olaylar.append(e)
	y.kitlik_tetiklendi.emit(e.kitlik_isyani.duplicate(true))
	return true

static func onarim_nedeni(y: KoyYonetimi) -> String:
	if y.son != "": return "Oyun sona erdi"
	if not durum(y).kapi_kirik: return "Ambar kapısı sağlam"
	if not y.kaynaklar.yeterli(ONARIM): return "4 taş ve 6 kereste gerekli"
	return ""

## Geç kapasite taşmasını mevcut EKO-15 bilançosuna da taşır.
static func raporla(y: KoyYonetimi, rapor: Dictionary) -> void:
	rapor["kitlik"] = durum(y)
	for e in rapor.olaylar:
		if not e.has("kitlik_isyani"): continue
		var ziyan: Dictionary = rapor.get("ziyan", {})
		var tasma: Dictionary = ziyan.get("tasma", {})
		for tur in e.kitlik_isyani.kapasite_ziyani:
			tasma[tur] = int(tasma.get(tur, 0)) + int(e.kitlik_isyani.kapasite_ziyani[tur])
		ziyan["tasma"] = tasma
		rapor["ziyan"] = ziyan

## Atomik oyuncu işlemi: çift tıklama/eksik malzeme bedeli tekrar kesmez.
static func onar(y: KoyYonetimi) -> bool:
	if not onarim_nedeni(y).is_empty() or not y.kaynaklar.harca(ONARIM): return false
	var d := durum(y)
	d.kapi_kirik = false
	y.set_meta(META, d)
	y._ambar_kapasitesi()
	return true

static func metin(y: KoyYonetimi) -> String:
	var d := durum(y)
	return "Kıtlık: %d/2 gece · Ambar kapısı %s · Ambar koruması %d/100%s" % [d.kitlik_gece_sayisi, "kırık" if d.kapi_kirik else "sağlam", koruma(y), " · Kapasite −%20; onarım: 4 taş + 6 kereste" if d.kapi_kirik else ""]

static func olay_metin(e: Dictionary) -> String:
	var d: Dictionary = e.kitlik_isyani
	var stok: PackedStringArray = []
	for tur in d.yagma: stok.append("%d %s" % [int(d.yagma[tur]), DemirZinciri.ad("koy.kaynak." + tur)])
	return "Kıtlık isyanı: ambar kapısı kırıldı. Yağma: %s (tavan %d). Moral −%d; ambar koruması %d/100. Kapı onarılana kadar kapasite −%%20." % [", ".join(stok) if not stok.is_empty() else "stok kaybı yok", YAGMA_TAVAN, d.moral, d.guvenlik]
