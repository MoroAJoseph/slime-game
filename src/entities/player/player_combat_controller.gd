class_name PlayerCombatController
extends Node3D

@onready var player: Player = get_parent()

# References to the current active setup
var active_weapon_node: Node3D   # The actual Gun.tscn instance
var active_weapon_data: WeaponData # The GunData resource (stats/fire mode)

# ===
# Built-In
# ===

func _ready() -> void:
	# Initialization logic if needed
	pass

# ===
# Local
# ===

## Connects the logical controller to the physical instance spawned by the Model Controller
func register_active_weapon(node: Node3D, data: WeaponData) -> void:
	active_weapon_node = node
	active_weapon_data = data
	
	# If the weapon needs specific initialization when gripped (like a laser turning on)
	if active_weapon_node and active_weapon_node.has_method("on_equipped"):
		active_weapon_node.on_equipped()

## Main entry point called by Player.gd during _process
func handle_combat_input(_delta: float) -> void:
	if not active_weapon_node or not active_weapon_data:
		return
	
	# Check for shooting based on weapon type
	if active_weapon_data is GunData:
		_handle_gun_input()
	#elif active_weapon_data is MeleeData: # Example for future expansion
		#_handle_melee_input()

## Routes reload requests from Player.gd to the active weapon node
func request_reload() -> void:
	if active_weapon_node and active_weapon_node.has_method("reload"):
		active_weapon_node.reload()

## Logic for determining when to trigger a shot based on Fire Mode
func _handle_gun_input() -> void:
	var gun_data = active_weapon_data as GunData
	
	# Safety check: Default to SEMI_AUTO if fire_mode isn't defined
	var fire_mode = gun_data.fire_mode if "fire_mode" in gun_data else 0 
	
	var is_trying_to_shoot: bool = false
	
	# 0 = Semi, 1 = Full Auto (Adjust based on your GunData enum)
	if fire_mode == 1: 
		is_trying_to_shoot = Input.is_action_pressed("player_shoot")
	else:
		is_trying_to_shoot = Input.is_action_just_pressed("player_shoot")
		
	if is_trying_to_shoot:
		_execute_shot()

## Calculates the 3D trajectory and tells the weapon node to fire
func _execute_shot() -> void:
	if not active_weapon_node.has_method("shoot"):
		return
	
	# Get the point the camera is looking at
	var target_3d_point = player.CAMERA_CONTROLLER.get_aim_target()
	
	# Get the barrel position from the weapon instance
	# Assumes your Gun.gd has a marker or variable for bullet spawn
	var barrel_pos = active_weapon_node.global_position
	if "bullet_spawn_node" in active_weapon_node:
		barrel_pos = active_weapon_node.bullet_spawn_node.global_position
	
	var direction = (target_3d_point - barrel_pos).normalized()
	
	# Tell the gun to perform the shoot logic (spawn projectile, raycast, etc.)
	active_weapon_node.shoot(direction)

func _handle_melee_input() -> void:
	if Input.is_action_just_pressed("player_shoot"):
		if active_weapon_node.has_method("attack"):
			active_weapon_node.attack()

# ===
# Events / Signals
# ===

# Add listeners for weapon-specific events here (e.g., out of ammo signal)
