## ISG-32: UI duraklatılırken modelin başsız atama API’si korunur.
extends RefCounted

static func acik(ekran: Node) -> bool:
	return is_instance_valid(ekran) and ekran.is_inside_tree() and not ekran.get_tree().paused and ekran.can_process()
