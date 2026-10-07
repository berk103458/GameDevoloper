## Sahne geçişinde sabit efekt havuzunu yeniden kullanıma hazırlar.
class_name EfektHavuzuTemizligi
extends RefCounted

static func temizle(havuz: Array, onbellek: Dictionary) -> void:
	for o in havuz:
		if is_instance_valid(o) and o is AudioStreamPlayer:
			o.stop()
			o.stream = null
	# Müzik/ortam oynatıcılarının kendi akışları durmaz; yalnız cache referansı kalkar.
	onbellek.clear()

static func biteni_birak(o: AudioStreamPlayer) -> void:
	if is_instance_valid(o) and not o.playing:
		o.stream = null
