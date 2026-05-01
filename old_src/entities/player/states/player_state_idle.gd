# Idle
extends PlayerState

# ===
# Parent
# ===

func physics_update(delta: float):
	if Input.is_action_just_pressed("player_jump") and _owner.is_on_floor():
		_transition_to(StateName.JUMP, null)
	elif not _owner._input_direction.is_zero_approx():
		_transition_to(StateName.WALK, null)
	else:
		_owner.apply_velocity(0.0, delta)
