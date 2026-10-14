## Tasarımcı tarafından ayarlanabilir blöf/ikna eğrisi.
extends Resource

@export_range(0.0, 1.0) var taban_olasilik: float = 0.6
@export var tecrube_katkisi: float = 0.02
@export var tansiyon_cezasi: float = 0.04
@export_range(0.0, 1.0) var asgari: float = 0.1
@export_range(0.0, 1.0) var azami: float = 0.95
@export var basarisiz_tansiyon_delta: int = 1
## ZAR-01: tansiyon eki kademeleri. Aralıklar KAP-02'den; sakin 0-3, gergin 4-7, panik 8-10. Değerler sorgu_kurallari.tres içindedir.
@export var zar_gergin_alt: int = 4
@export var zar_panik_alt: int = 8
@export var zar_ek_sakin: int = 0
@export var zar_ek_gergin: int = 1
@export var zar_ek_panik: int = 2

func olasilik(tecrube: int, tansiyon: int) -> float:
	return clampf(taban_olasilik + maxi(0, tecrube) * tecrube_katkisi - clampi(tansiyon, 0, 10) * tansiyon_cezasi, asgari, azami)
