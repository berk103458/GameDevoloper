extends Action

var tur := "ekmek"


func get_title() -> String:
	return tur


func get_cost(_agent_blackboard: GdPAIBlackboard, _world_state: GdPAIBlackboard) -> float:
	return 1.0


func simulate_effect(agent_blackboard: GdPAIBlackboard, _world_state: GdPAIBlackboard) -> void:
	var anahtar := String({"ekmek": "tok", "su": "sulandi", "pazar": "alisveris"}.get(tur, "tok"))
	agent_blackboard.set_property(anahtar, true)


func perform_action(agent: GdPAIAgent, _delta: float) -> Status:
	if agent.entity != null:
		agent.entity.set_meta(&"ihtiyac", tur)
	return Status.SUCCESS
