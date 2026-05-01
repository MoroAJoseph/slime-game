# Walk
extends PlayerState

var _target_speed: float = 0.0

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	_target_speed = _owner_data.walk_speed

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("player_jump") and _owner.is_grounded_cone():
		_transition_to(StateName.JUMP, null)
		return
	if _owner._input_direction.is_zero_approx():
		_transition_to(StateName.IDLE, null)
		return
	if Input.is_action_pressed("player_sprint"):
		_transition_to(StateName.RUN, null)
		return
	_owner.apply_velocity(_owner_data.walk_speed, delta)
