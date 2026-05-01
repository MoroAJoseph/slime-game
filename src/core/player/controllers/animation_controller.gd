extends Node

@onready var _animation_tree: AnimationTree = $AnimationTree

var _last_air_state: String = ""
var _jump_was_in_place: bool = false
var _force_land_check: bool = false
var _current_weapon_subtype_string: String = "Unarmed"
var _current_weapon_data

# ===
# Built-In
# ===

# ===
# Public
# ===

func update(delta: float, state_name: String, mode: int, weapon_data, is_aiming: bool) -> void:
	if not _animation_tree or not _animation_tree.active:
		return

	_current_weapon_data = weapon_data
	var is_action = (mode == 1)
	var branch = "Action_" if is_action else "Adventure_"

	# Weapon Mode (Action vs Adventure)
	_set_parameter("Mode_Select/transition_request", "Action" if is_action else "Adventure")

	# Aim blending - Only if not unarmed
	if _current_weapon_subtype_string != "Unarmed":
		_update_aim_blend(delta, is_aiming)

	# Air/Ground branching
	var player = owner as Player
	var is_in_air_branch = not player.is_grounded_cone()
	_set_parameter(branch + "Select/transition_request", "Air" if is_in_air_branch else "Ground")

	if is_in_air_branch:
		_process_air_logic(player, branch)
	else:
		_process_ground_logic(delta, player, state_name, branch, is_action)

func request_landing_state() -> void:
	_force_land_check = true

# ===
# Private
# ===

func _update_root_conditions() -> void:
	var is_unarmed = (_current_weapon_subtype_string == "Unarmed")
	var is_rifle = (_current_weapon_subtype_string == "Rifle")
	
	_animation_tree.set("parameters/conditions/is_unarmed", is_unarmed)
	_animation_tree.set("parameters/conditions/is_rifle", is_rifle)
	
	# Future-proofing for other types
	# var is_pistol = (_current_weapon_subtype_string == "Pistol")
	# _animation_tree.set("parameters/conditions/is_pistol", is_pistol)

func _process_ground_logic(delta: float, player: Player, state_name: String, branch: String, is_action: bool) -> void:
	var ground_target = "Jump" if state_name == "Jump" else "Locomotion"
	_set_parameter(branch + "Ground_Select/transition_request", ground_target)

	var is_running = (state_name == "Run")
	_set_parameter(branch + "Locomotion_Select/transition_request", "Run" if is_running else "Walk")

	var move_type = "Run" if is_running else "Walk"
	var path = branch + move_type + "/blend_position"

	if is_action:
		var target_value = Vector2(player._input_direction.x, -player._input_direction.y)
		var current_value = _get_parameter(path)
		if current_value == null: current_value = Vector2.ZERO
		_set_parameter(path, current_value.lerp(target_value, 15.0 * delta))
	else:
		var target_value = 1.0 if player._input_direction.length() > 0.1 else 0.0
		var current_value = _get_parameter(path)
		if current_value == null: current_value = 0.0
		_set_parameter(path, lerpf(current_value, target_value, 10.0 * delta))

	_last_air_state = ""

func _process_air_logic(player: Player, branch: String) -> void:
	if _last_air_state == "":
		_jump_was_in_place = player._input_direction.length() < 0.1
		_set_parameter(branch + "Jump_Select/transition_request", "InPlace" if _jump_was_in_place else "InMotion")

	var target_air_state: String
	
	if _force_land_check or player.is_grounded_cone():
		target_air_state = "Land"
		_force_land_check = false 
	else:
		target_air_state = "Airborne"

	if target_air_state != _last_air_state:
		_set_parameter(branch + "Air_Select/transition_request", target_air_state)
		_last_air_state = target_air_state

func _update_aim_blend(delta: float, is_aiming: bool) -> void:
	var path = "Aim_Blend/blend_amount"
	var current = _get_parameter(path)
	if current != null:
		var target = 1.0 if is_aiming else 0.0
		_set_parameter(path, lerpf(current, target, 10.0 * delta))

func _set_parameter(sub_path: String, value) -> void:
	var path = _get_valid_path(sub_path)
	if path != "":
		_animation_tree.set(path, value)

func _get_parameter(sub_path: String):
	var path = _get_valid_path(sub_path)
	return _animation_tree.get(path) if path != "" else null

func _get_valid_path(sub_path: String) -> String:
	# Try the current weapon (e.g., parameters/Rifle/...)
	var full_path = "parameters/" + _current_weapon_subtype_string + "/" + sub_path
	if _animation_tree.get(full_path) != null:
		return full_path
		
	# Fallback to Unarmed (e.g., parameters/Unarmed/...)
	var fallback = "parameters/Unarmed/" + sub_path
	if _animation_tree.get(fallback) != null:
		return fallback
		
	return ""
