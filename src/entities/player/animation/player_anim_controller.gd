class_name PlayerAnimationController
extends Node

@export var _animation_tree: AnimationTree

var _current_weapon_name: String = "Rifle"
var _last_air_state: String = ""
var _jump_was_inplace: bool = false 
var _force_land_check: bool = false

# ===
# Local
# ===
func update(delta: float, state_name: String, mode: int, weapon_name: String, is_aiming: bool) -> void:
	if not _animation_tree or not _animation_tree.active:
		return

	_current_weapon_name = weapon_name
	var is_action = (mode == 1)
	var branch = "Action_" if is_action else "Adventure_"

	# Weapon Mode
	_set_p("Mode_Select/transition_request", "Action" if is_action else "Adventure")

	# Aim blending
	_update_aim_blend(delta, is_aiming)

	# Air/Ground branching
	var player = owner as Player
	var is_in_air_branch = not player.is_grounded_cone()
	_set_p(branch + "Select/transition_request", "Air" if is_in_air_branch else "Ground")

	if is_in_air_branch:
		_process_air_logic(player, branch)
	else:
		_process_ground_logic(delta, player, state_name, branch, is_action)

func _process_ground_logic(delta: float, player: Player, state_name: String, branch: String, is_action: bool) -> void:
	var ground_target = "Jump" if state_name == "Jump" else "Locomotion"
	_set_p(branch + "Ground_Select/transition_request", ground_target)

	var is_running = (state_name == "Run")
	_set_p(branch + "Locomotion_Select/transition_request", "Run" if is_running else "Walk")

	var move_type = "Run" if is_running else "Walk"
	var path = branch + move_type + "/blend_position"

	if is_action:
		var target_vec = Vector2(player._input_direction.x, -player._input_direction.y)
		var current_vec = _get_p(path)
		if current_vec == null: current_vec = Vector2.ZERO
		_set_p(path, current_vec.lerp(target_vec, 15.0 * delta))
	else:
		var target_f = 1.0 if player._input_direction.length() > 0.1 else 0.0
		var current_f = _get_p(path)
		if current_f == null: current_f = 0.0
		_set_p(path, lerpf(current_f, target_f, 10.0 * delta))

	_last_air_state = ""

func _process_air_logic(player: Player, branch: String) -> void:
	if _last_air_state == "":
		_jump_was_inplace = player._input_direction.length() < 0.1
		_set_p(branch + "Jump_Select/transition_request", "InPlace" if _jump_was_inplace else "Moving")

	var target_air_state: String
	
	# Logic: Play Land only if we are about to hit the ground.
	# Otherwise, play Airborne (the jump/fall loop).
	if _force_land_check or player.is_grounded_cone():
		target_air_state = "Land"
		# Reset the force check once we've successfully transitioned to Land
		_force_land_check = false 
	else:
		# This covers both the upward jump and the downward fall
		target_air_state = "Airborne"

	if target_air_state != _last_air_state:
		_set_p(branch + "Air_Select/transition_request", target_air_state)
		_last_air_state = target_air_state

func _update_aim_blend(delta: float, is_aiming: bool) -> void:
	var path = "Aim_Blend/blend_amount"
	var current = _get_p(path)
	if current != null:
		var target = 1.0 if is_aiming else 0.0
		_set_p(path, lerpf(current, target, 10.0 * delta))

func request_landing_state() -> void:
	_force_land_check = true

func _set_p(sub_path: String, value) -> void:
	var full_path = "parameters/" + _current_weapon_name + "/" + sub_path
	if _animation_tree.get(full_path) != null:
		_animation_tree.set(full_path, value)
	else:
		push_error("ANIM_TREE: Missing path: " + full_path)

func _get_p(sub_path: String):
	var full_path = "parameters/" + _current_weapon_name + "/" + sub_path
	return _animation_tree.get(full_path)
