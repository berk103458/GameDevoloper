# gdlint: disable=max-line-length
## SYS-19: 1→2. perde geçişi. Nüfus agalik_nufus'a (18) varınca mevcut _asamalar "Köy oturdu"
## (agalik) açılır; oyuncu "Ağa olarak devam et" der. Gün/gece sayacı sıfırlanmaz: 2. perde kendi
## sayacını geçiş gününden tutar ve OyunAyarlari.perde2_hedef_gece (12) gece dayanılınca biter.
extends RefCounted

const META := &"perde2_baslangic"

## İlk 2. perde gününün mutlak gün numarası; agalik yoksa -1.
static func baslangic(y: KoyYonetimi) -> int:
	return int(y.get_meta(META, -1))

## Tamamlanan 2. perde gecesi (gün sayacı sıfırlanmadan).
static func gece(y: KoyYonetimi) -> int:
	return maxi(0, y.gun - baslangic(y)) if y.agalik and baslangic(y) >= 0 else 0

## KoyYonetimi.gece içinde _asamalar'dan hemen sonra: geçiş gecesinde başlangıç işaretlenir.
static func isaretle(y: KoyYonetimi, olaylar: Array[Dictionary], hedef: int) -> void:
	if not y.agalik or baslangic(y) >= 0: return
	y.set_meta(META, y.gun + 1)
	olaylar.append({"anahtar": "perde_gecisi", "perde_gecisi": {"tur": "basladi", "hedef": hedef, "gun": y.gun + 1}})

## Optional/legacy kayıt: geçerli başlangıç korunur; alan yok/bozuk/ileri tarih -1 olur ve
## agalik açıksa sonraki gece isaretle ile başlar (kesintisiz oyunla aynı rapor/JSON; anında bitmez).
static func yukle(y: KoyYonetimi, v: Variant) -> void:
	var gecerli: bool = y.agalik and (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= 0 and float(v) <= y.gun + 1
	y.set_meta(META, int(v) if gecerli else -1)

## Oturum.gece_sonu içinde: 2. perde hedef geceye ulaştıysa mevcut "zafer" sonu (SYS-20 sonu seçer).
static func denetle(y: KoyYonetimi, r: Dictionary, hedef: int) -> void:
	if y.son != &"" or not y.agalik or baslangic(y) < 0 or gece(y) < hedef: return
	y.son = KoyYonetimi.SON_ZAFER
	r["son"] = y.son
	r.olaylar.append({"anahtar": "perde_gecisi", "perde_gecisi": {"tur": "bitti", "hedef": hedef, "gun": y.gun}})

static func olay_metin(e: Dictionary) -> String:
	var d: Dictionary = e.perde_gecisi
	return PerdeMetni.metin_al(String(d.tur), int(d.hedef), int(d.get("gun", 1)))
