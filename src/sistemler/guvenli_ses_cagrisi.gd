## Optional autoload adapter; headless harnesses and missing audio stay safe.
extends RefCounted

static func oynat(ad: StringName, db: float = 0.0) -> bool:
	var agac := Engine.get_main_loop() as SceneTree
	if agac == null:
		return false
	var ses := agac.root.get_node_or_null("Ses")
	if ses == null or not ses.has_method("oynat"):
		return false
	return bool(ses.call("oynat", ad, db))
