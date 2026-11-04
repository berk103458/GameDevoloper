## AYR-47: TST-03 ölçüm kancasına `AYAR` satırı. Değişim başına bir satır.
## TST-03 günlüğü bu diziye bağlanır; dosyaya kendiliğinden yazılmaz.
extends RefCounted

static var satirlar: Array[String] = []


static func ayar(anahtar: StringName, eski: Variant, yeni: Variant) -> void:
	if eski == yeni:
		return
	satirlar.append("AYAR %s %s -> %s" % [anahtar, eski, yeni])


static func temizle() -> void:
	satirlar.clear()
