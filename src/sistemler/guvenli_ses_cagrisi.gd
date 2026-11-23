## Zorunlu diyalog sesi hatasını anahtar başına bir kez bildirir.
extends RefCounted

static var _bildirilen: Dictionary = {}


static func oynat(ad: StringName, db: float = 0.0, zorunlu: bool = false) -> bool:
	var agac := Engine.get_main_loop() as SceneTree
	var ses := agac.root.get_node_or_null("Ses") if agac != null else null
	var calindi := ses != null and ses.has_method("oynat") and bool(ses.call("oynat", ad, db))
	if zorunlu and not calindi and not _bildirilen.has(ad):
		_bildirilen[ad] = true
		push_warning("Diyalog sesi çalmadı (%s): %s" % [
			"Ses autoload yok veya hazır değil" if ses == null or not ses.has_method("oynat") else "akış yüklenemedi",
			HazirSesKaynaklari.yol(String(ad)),
		])
	return calindi
