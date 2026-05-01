class_name PlayerCombatController
extends Node

@onready var player: Player = get_parent()

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

# ===
# Private
# ===

func _handle_gun_input() -> void:
	var is_just_pressed = Input.is_action_just_pressed("player_shoot")
	var is_held = Input.is_action_pressed("player_shoot")
	
	var ray_data = player.get_viewport_raycast_data(1000)
	var bullet_target_position: Vector3
	
	if not ray_data.is_empty():
		bullet_target_position = ray_data.position
	else:
		var camera = get_viewport().get_camera_3d()
		var screen_center = get_viewport().get_visible_rect().size / 2
		var ray_dir = camera.project_ray_normal(screen_center)
		bullet_target_position = camera.global_position + (ray_dir * 1000.0)
	
	var spawn_transform: Transform3D = active_weapon_node.global_transform
	if active_weapon_node.has_method("get_projectile_spawn"):
		spawn_transform = active_weapon_node.get_projectile_spawn()
	
	var direction = (bullet_target_position - spawn_transform.origin).normalized()

	if active_weapon_node.has_method("request_fire"):
		active_weapon_node.request_fire(is_just_pressed, is_held, direction, spawn_transform)
