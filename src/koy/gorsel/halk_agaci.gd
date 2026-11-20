## Köylü, tüccar ve hayvan için tek davranış ağacı. Mevcut rota kurulumu durur.
class_name HalkAgaci
extends RefCounted

const GOREV := preload("res://src/koy/gorsel/halk_gorev.gd")


static func bagla(halk: KoyHalkHareketi) -> void:
	for id in halk.modeller:
		_oyuncu(halk.modeller[id], halk, int(id), "koylu")
	for n in halk.get_children():
		if n is CobanSurusu:
			_oyuncu(n, halk, -1, "hayvan")
		elif n.get_script() != null and String(n.get_script().resource_path).ends_with("kurt_surusu.gd"):
			_oyuncu(n, halk, -1, "hayvan")


static func agac() -> BehaviorTree:
	var kok := BTSelector.new()
	_dizi(kok, ["alarm", "alarm_tepki"])
	_dizi(kok, ["hayvan", "gunduz", "is"])
	_dizi(kok, ["hayvan", "dolas"])
	_dizi(kok, ["gece", "eve"])
	_dizi(kok, ["aksam", "bekle"])
	_dizi(kok, ["gunduz", "is"])
	var bekleyen := GOREV.new()
	bekleyen.kip = "bekle"
	kok.add_child(bekleyen)
	var agac := BehaviorTree.new()
	agac.set_root_task(kok)
	return agac


static func _dizi(kok: BTSelector, kipler: Array) -> void:
	var dizi := BTSequence.new()
	for kip in kipler:
		var g := GOREV.new()
		g.kip = String(kip)
		dizi.add_child(g)
	kok.add_child(dizi)


static func _oyuncu(govde: Node, halk: KoyHalkHareketi, id: int, tur: String) -> void:
	var var_olan := govde.get_node_or_null(^"limbo")
	if var_olan != null:
		var_olan.blackboard.set_var("id", id)
		var_olan.blackboard.set_var("tur", tur)
		return
	var p := BTPlayer.new()
	p.name = &"limbo"
	p.set_scene_root_hint(halk.sahne)
	p.behavior_tree = agac()
	govde.add_child(p)
	p.set_meta(&"govde", govde)
	p.blackboard.set_var("id", id)
	p.blackboard.set_var("tur", tur)
	p.blackboard.set_var("halk", halk)
