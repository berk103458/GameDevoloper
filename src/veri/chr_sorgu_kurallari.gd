## Tasarımcı tarafından ayarlanabilir blöf/ikna eğrisi.
extends Resource

@export_range(0.0, 1.0) var taban_olasilik: float = 0.6
@export var tecrube_katkisi: float = 0.02
@export var tansiyon_cezasi: float = 0.04
@export_range(0.0, 1.0) var asgari: float = 0.1
@export_range(0.0, 1.0) var azami: float = 0.95
@export var basarisiz_tansiyon_delta: int = 1

func olasilik(tecrube: int, tansiyon: int) -> float:
	return clampf(taban_olasilik + maxi(0, tecrube) * tecrube_katkisi - clampi(tansiyon, 0, 10) * tansiyon_cezasi, asgari, azami)
