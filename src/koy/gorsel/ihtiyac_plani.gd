## GdPlanningAI: tüccar ve en çok iki köylü için açlık, su, alışveriş.
## Plan yalnız istek üzerine kurulur. Ekonomi sayıları değişmez. Ayar kapalıysa hiç ajan kurulmaz.
class_name IhtiyacPlani
extends RefCounted

const AYAR := "res://data/ayarlar/eklenti_bag.json"
const AZAMI := 3

static var son_hata := ""


static func acik() -> bool:
	var veri = JSON.parse_string(FileAccess.get_file_as_string(AYAR))
	return veri is Dictionary and bool(veri.get("ihtiyac_plani", false))


static func bagla(halk: KoyHalkHareketi) -> void:
	if not acik():
		return
	if halk.get_tree() == null:
		return
	var dunya := halk.get_tree().root.get_node_or_null(^"GdPAIWorld")
	if dunya == null:
		dunya = GdPAIWorldNode.new()
		dunya.name = &"GdPAIWorld"
		dunya.blackboard_plan = GdPAIBlackboardPlan.new()
		halk.get_tree().root.add_child.call_deferred(dunya)
		bagla.call_deferred(halk)
		return
	var secilen: Array[Koylu] = []
	for k in halk.sahne.yonetim.koylular:
		if k.sinif == &"esnaf":
			secilen.append(k)
			break
	for k in halk.sahne.yonetim.koylular:
		if secilen.size() >= AZAMI:
			break
		if secilen.has(k):
			continue
		if k.sinif == &"asker" or k.ac or secilen.is_empty():
			secilen.append(k)
	for k in secilen:
		if not halk.modeller.has(k.id):
			continue
		_ajan(halk.modeller[k.id], k)


static func _ajan(govde: Node3D, k: Koylu) -> void:
	if govde.get_node_or_null(^"ihtiyac") != null:
		return
	var config := GdPAIAgentConfig.new()
	config.planning_strategy = GdPAIAgentConfig.PlanningStrategy.ON_DEMAND
	config.max_recursion = 4
	config.iteration_budget = 400
	config.time_slice_ms = 2
	config.blackboard_plan = GdPAIBlackboardPlan.new()
	config.blackboard_plan.blackboard_backend = {
		"ac": k.ac,
		"susuzluk": k.aclik >= 4,
		"pazar": k.sinif == &"esnaf",
		"tok": not k.ac,
		"sulandi": k.aclik < 4,
		"alisveris": k.sinif != &"esnaf",
	}
	config.behavior_configs = [load("res://src/koy/gorsel/plan/ihtiyac_davranisi.gd").new()]
	var ajan := GdPAIAgent.new()
	ajan.name = &"ihtiyac"
	ajan.entity = govde
	ajan.config = config
	govde.add_child(ajan)
	ajan.request_plan()
