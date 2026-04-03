# Exit
extends PlayerState

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	_owner.velocity = Vector3.ZERO
	
	var tween = _owner.create_tween()
	tween.tween_property(_owner, "global_position:y", _owner.global_position.y + 5.0, 1.0)
	
	await tween.finished
	var level = _owner.get_tree().get_first_node_in_group("Level")
	if level:
		level._on_level_cleared()
