# Fall
extends PlayerState

# ===
# Parent
# ===

func physics_update(delta: float) -> void:
	var target_speed = 0.0 if _owner._input_direction.is_zero_approx() else _owner_data.walk_speed
	_owner.apply_velocity(target_speed, delta)

	if _owner.is_grounded_cone():
		var target: StateName = StateName.IDLE if _owner._input_direction.is_zero_approx() else StateName.WALK
		_transition_to(target, null)
