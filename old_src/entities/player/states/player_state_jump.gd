# Jump
extends PlayerState

var _air_time: float = 0.0
var _source_was_idle: bool = false
var _source_was_walk: bool = false
var _source_was_run: bool = false

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	_air_time = 0.0
	_source_was_idle = (_prev_state_path == get_state_name(StateName.IDLE))
	_source_was_walk = (_prev_state_path == get_state_name(StateName.WALK))
	_source_was_run = (_prev_state_path == get_state_name(StateName.RUN))
	
	_owner.velocity.y = _owner_data.jump_force

func physics_update(delta: float) -> void:
	_air_time += delta
	
	# 1. Determine the horizontal speed based on where we came from
	var target_speed: float = 0.0
	
	if _source_was_run:
		target_speed = _owner_data.run_speed
	elif _source_was_walk:
		target_speed = _owner_data.walk_speed
	elif _source_was_idle and _air_time < 0.2:
		# Small window where idle jumps stay vertical
		target_speed = 0.0
	else:
		# Default fallback (e.g. if they start moving mid-air after an idle jump)
		target_speed = _owner_data.walk_speed

	# 2. Apply that speed to the movement logic
	_owner.apply_velocity(target_speed, delta)

	# 3. Variable Jump Height (Cut vertical velocity if button released early)
	if Input.is_action_just_released("player_jump") and _owner.velocity.y > 0.0:
		_owner.velocity.y *= 0.5

	# 4. Landing Logic
	if _owner.is_grounded_cone() and _air_time > 0.1:
		var target: StateName = StateName.IDLE if _owner._input_direction.is_zero_approx() else StateName.WALK
		_transition_to(target, null)
