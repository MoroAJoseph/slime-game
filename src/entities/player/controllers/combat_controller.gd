class_name PlayerCombatController
extends Node

@onready var player: Player = get_parent()

# References to the current active setup
var active_weapon_node: Node3D
var active_weapon_data: WeaponData
var current_slot: int = 0
var is_sheathed: bool = false

# ===
# Public
# ===

func register_active_weapon(node: Node3D, data: WeaponData, slot: int) -> void:
	active_weapon_node = node
	active_weapon_data = data
	current_slot = slot
	is_sheathed = false
	
	if active_weapon_node and active_weapon_node.has_method("on_equipped"):
		active_weapon_node.on_equipped()

func toggle_sheath() -> void:
	is_sheathed = !is_sheathed

func handle_combat_input(_delta: float) -> void:
	if is_sheathed or not active_weapon_node or not active_weapon_data:
		return
	
	if active_weapon_data is GunData:
		_handle_gun_input()

func request_reload() -> void:
	if active_weapon_node and active_weapon_node.has_method("reload"):
		active_weapon_node.reload()

func _handle_gun_input() -> void:
	var gun_data = active_weapon_data as GunData
	var fire_mode = gun_data.fire_mode if "fire_mode" in gun_data else 0 
	
	var is_trying_to_shoot: bool = false
	
	match fire_mode:
		GunResource.GunFireMode.FULL_AUTO:
			is_trying_to_shoot = Input.is_action_pressed("player_shoot")
		GunResource.GunFireMode.SEMI_AUTO:
			is_trying_to_shoot = Input.is_action_just_pressed("player_shoot")
		GunResource.GunFireMode.BURST:
			pass
		GunResource.GunFireMode.BEAM:
			pass
		GunResource.GunFireMode.CHARGE:
			pass
	
	if is_trying_to_shoot:
		_execute_shot()

func _execute_shot() -> void:
	if not active_weapon_node or not active_weapon_node.has_method("shoot"):
		return
	
	# 1. Get the raycast dictionary
	var ray_data = player.get_viewport_raycast_data(1000)
	var bullet_target_position: Vector3
	
	# 2. Check if the ray hit something (is the dictionary NOT empty?)
	if not ray_data.is_empty():
		bullet_target_position = ray_data.position
	else:
		# Fallback: Aim at a point 1000m in front of the camera if nothing is hit
		var camera = player.CAMERA_CONTROLLER.CAMERA
		var screen_center = get_viewport().get_visible_rect().size / 2
		var ray_dir = camera.project_ray_normal(screen_center)
		bullet_target_position = camera.global_position + (ray_dir * 1000.0)
	
	# 3. Determine spawn point
	var bullet_spawn_position = active_weapon_node.global_position
	if "bullet_spawn_node" in active_weapon_node:
		bullet_spawn_position = active_weapon_node.bullet_spawn_node.global_position
	
	# 4. Calculate direction and fire
	var direction = (bullet_target_position - bullet_spawn_position).normalized()
	active_weapon_node.shoot(direction)

func _handle_melee_input() -> void:
	if Input.is_action_just_pressed("player_shoot"):
		if active_weapon_node.has_method("attack"):
			active_weapon_node.attack()
