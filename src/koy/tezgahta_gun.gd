## TEZ-01: dört tezgâhın yeri. Ağıl, değirmen, demirhane ve bez tezgâhı ayrı iş
## yerleridir; yer kaydı düğüm kimliğidir, düz ad yazılmaz. Düğümü olmayan ya da
## ızgara hücresinin dışındaki yer iş almaz. ANI-08 düğüm hareketi tek okumadan
## gelir; yeni sahne, yeni meslek ve YAP kademesi açılmaz.
class_name TezgahtaGun
extends RefCounted

## Sabit sıra; yer kimliği → karşılık gelen yapı türü (dördüncü yer bez tezgâhı).
const YERLER := {"agil": "agil", "degirmen": "degirmen", "demirhane": "demirhane", "bez": "bez_evi"}
const SIRA: Array[String] = ["agil", "degirmen", "demirhane", "bez"]
const YOK := Vector2i(-1, -1)

static func yer_mi(yer: String) -> bool:
	return SIRA.has(yer)

## Yerin ANI-08 düğümü: hazır yapının ızgara hücresi. Düğüm yoksa (-1, -1).
static func dugum(y: KoyYonetimi, yer: String) -> Vector2i:
	if not yer_mi(yer): return YOK
	var tur: String = YERLER[yer]
	for b in y.binalar:
		if b.tur == tur and b.hazir(): return b.hucre
	return YOK

static func dugum_var_mi(y: KoyYonetimi, yer: String) -> bool:
	return dugum(y, yer).x >= 0

## Açık iş: düğümü olan ve hücresi ızgara içinde olan yer 1; düğümü olmayan ya da
## ızgara hücresinin dışındaki yer 0.
static func acik_is(y: KoyYonetimi, yer: String) -> int:
	if not dugum_var_mi(y, yer): return 0
	return 1 if y.izgara.icinde(dugum(y, yer)) else 0

static func acik_isler(y: KoyYonetimi) -> Dictionary:
	var d := {}
	for yer in SIRA: d[yer] = acik_is(y, yer)
	return d

## ANI-08 düğüm hareketi: yapı türü → dov/pisir; yoksa boş. Tek okuma, yazma yok.
static func ani08_hareket(tur: String) -> String:
	return String(ZanaatTezgahi.AYAR.turler.get(tur, ""))

## MEV-01 mevsimi; dört yer sabittir, kış için beşinci yer açılmaz.
static func mevsim(y: KoyYonetimi) -> int:
	return y.mevsim()