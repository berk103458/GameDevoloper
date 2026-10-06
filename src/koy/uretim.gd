## Üretim formülü (design/gdd/koy-yonetimi.md, F4–F5):
##   Günlük Üretim = Temel × (0.5 + Stat / 10) × Bileşik Flag Çarpanı
##   Bileşik Flag Çarpanı = clamp(Π Flag Çarpanları, alt, üst)
class_name Uretim
extends RefCounted

## Olumsuz bayraklar (çarpan `olumsuz`).
const OLUMSUZ: Array[String] = ["tembel", "agir_yarali", "hasta"]


## Bir çalışanın bayraklarından bileşik çarpan. `uzmanlik`: yapının istediği uzmanlık (`ciftci` → `usta_ciftci`).
static func bilesik_carpan(bayraklar: PackedStringArray, uzmanlik: String, carpanlar: Dictionary, alt: float, ust: float) -> float:
	var c := 1.0
	for b in bayraklar:
		if uzmanlik != "" and b == "usta_" + uzmanlik:
			c *= float(carpanlar.get("usta", 1.3))
		elif b in OLUMSUZ:
			c *= float(carpanlar.get("olumsuz", 0.7))
	return clampf(c, alt, ust)


## Günlük üretim (ondalıklı; ambar tam sayı tutar, artık bir sonraki güne devreder).
static func gunluk(temel: float, stat: int, carpan: float) -> float:
	return temel * (0.5 + float(stat) / 10.0) * carpan
