extends GdPAIBehaviorConfig


func _populate(goals: Array[Goal], actions: Array[Action], _updaters: Array[PropertyUpdater]) -> void:
	for tur in ["ekmek", "su", "pazar"]:
		var hedef: Goal = load("res://src/koy/gorsel/plan/ihtiyac_hedefi.gd").new()
		hedef.tur = tur
		goals.append(hedef)
		var eylem: Action = load("res://src/koy/gorsel/plan/ihtiyac_eylemi.gd").new()
		eylem.tur = tur
		actions.append(eylem)
