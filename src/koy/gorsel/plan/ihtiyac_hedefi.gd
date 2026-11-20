extends Goal

var tur := "ekmek"


func get_title() -> String:
	return tur


func get_reward(agent: GdPAIAgent) -> float:
	match tur:
		"ekmek":
			return 10.0 if bool(agent.blackboard.get_property("ac")) else 0.0
		"su":
			return 8.0 if bool(agent.blackboard.get_property("susuzluk")) else 0.0
		"pazar":
			return 6.0 if bool(agent.blackboard.get_property("pazar")) else 0.0
	return 0.0


func get_desired_state(_agent: GdPAIAgent) -> Array[Precondition]:
	var anahtar := String({"ekmek": "tok", "su": "sulandi", "pazar": "alisveris"}.get(tur, "tok"))
	return [Precondition.agent_property_equal_to(anahtar, true)]
