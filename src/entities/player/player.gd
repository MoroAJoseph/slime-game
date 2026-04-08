class_name Player
extends CharacterBody3D

@export var data: PlayerData
@export_range(0.01, 1.0) var _mouse_sensitivity: float = 0.15

@onready var MINIMAP_ICON: Sprite3D = $MinimapIcon
@onready var INTERACTABLE_DETECTOR: InteractableDetector = $InteractableDetector
@onready var INTERACTABLE_SENSOR: InteractableSensor = $InteractableSensor
@onready var STATE_MACHINE: StateMachine = $StateMachine
@onready var MODEL_CONTROLLER: PlayerModelController = $ModelController
@onready var CAMERA_CONTROLLER: PlayerCameraController = $CameraController
@onready var ANIMATION_CONTROLLER: PlayerAnimationController = $AnimationController
@onready var COMBAT_CONTROLLER: PlayerCombatController = $CombatController

enum InputMode { ADVENTURE, ACTION }

var _current_weapon_data: WeaponData
var _input_direction: Vector2 = Vector2.ZERO
var _camera_input: Vector2 = Vector2.ZERO
var _last_movement_direction: Vector3 = Vector3.BACK
var _input_mode: InputMode = InputMode.ADVENTURE
var _was_aiming: bool = false
var _hurt_enabled: bool = false
var _input_enabled: bool = false
var _current_hovered_sensor: GazeSensor = null

# Grounding settings
var _cone_ray_count: int = 8
var _cone_ray_length: float = 0.3

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)
	_setup_loadout()
	spawn()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_camera_input = event.relative * _mouse_sensitivity

func _process(delta: float) -> void:
	if get_tree().paused: return
	
	_handle_dev_input()
	_update_input_mode()
	
	# Camera & Rotation
	CAMERA_CONTROLLER.rotate_camera(_camera_input, _input_mode == InputMode.ACTION, delta)
	_camera_input = Vector2.ZERO
	apply_rotation(delta)

	# Combat Delegation
	if _input_mode == InputMode.ACTION:
		COMBAT_CONTROLLER.handle_combat_input(delta)
	
	if _input_enabled:
		if Input.is_action_just_pressed("player_interact"):
			_attempt_interact()
		
		if Input.is_action_just_pressed("player_reload"):
			COMBAT_CONTROLLER.request_reload()

	_handle_loadout_input()
	_update_animations(delta)
	_update_minimap_icon()
	_publish_look_at_target()

func _physics_process(_delta: float) -> void:
	if not _input_enabled: 
		_input_direction = Vector2.ZERO
	else:
		_input_direction = Input.get_vector(
			"player_move_left", "player_move_right", 
			"player_move_forward", "player_move_backward"
		)

# ===
# Public
# ===

func get_viewport_raycast_data(max_dist: float = 15.0) -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	var camera = CAMERA_CONTROLLER.CAMERA
	var screen_center = get_viewport().get_visible_rect().size / 2
	
	var ray_origin = camera.project_ray_origin(screen_center)
	var ray_dir = camera.project_ray_normal(screen_center)
	var ray_end = ray_origin + (ray_dir * max_dist)
	
	var base_exclude: Array[RID] = [self.get_rid(), INTERACTABLE_DETECTOR.get_rid(), INTERACTABLE_SENSOR.get_rid()]
	
	# --- Sensor Multi-Scan ---
	var current_exclude = base_exclude.duplicate()
	var max_attempts = 8 # Safety limit
	
	for i in range(max_attempts):
		var sensor_query = PhysicsRayQueryParameters3D.create(
			ray_origin, 
			ray_end, 
			Constants.LAYER_PHYSICS_3D['Interaction'],
			current_exclude
		)
		sensor_query.collide_with_areas = true
		sensor_query.collide_with_bodies = false
		
		var hit = space_state.intersect_ray(sensor_query)
		
		if hit.is_empty():
			break # Hit nothing on this layer
			
		if hit.collider is GazeSensor:
			hit["layer"] = hit.collider.collision_layer
			return hit # Found it!
			
		# If we hit something on the Interaction layer that ISN'T a GazeSensor,
		# add it to the exclusion list and keep going.
		current_exclude.append(hit.collider.get_rid())

	# --- World Check (Fallback) ---
	var world_query = PhysicsRayQueryParameters3D.create(
		ray_origin, 
		ray_end, 
		Constants.LAYER_PHYSICS_3D['World'],
		base_exclude
	)
	world_query.collide_with_bodies = true
	
	var world_hit = space_state.intersect_ray(world_query)
	if not world_hit.is_empty():
		world_hit["layer"] = world_hit.collider.collision_layer
		return world_hit
		
	return {}


func get_minimap_forward() -> Vector3:
	var cam_forward = -CAMERA_CONTROLLER.get_horizontal_basis().z
	cam_forward.y = 0
	return cam_forward.normalized()

func spawn() -> void:
	_hurt_enabled = false
	_input_enabled = true
	MODEL_CONTROLLER.reset_visuals()
	MODEL_CONTROLLER.set_spawn_visuals(true)
	
	var tween = create_tween()
	tween.tween_method(
		MODEL_CONTROLLER.update_spawn_visual, 
		-0.2, # Start slightly below feet
		2.0,  # End above head
		3.0   # Duration in seconds
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(
		func(): 
			MODEL_CONTROLLER.set_spawn_visuals(false)
			_hurt_enabled = true
	)

func die() -> void:
	_hurt_enabled = false
	_input_enabled = false
	STATE_MACHINE._transition_to_next_state("Dead")
	MODEL_CONTROLLER.trigger_death_visuals()
	await get_tree().create_timer(3.0).timeout
	WorldEvent.EntityDied.new(self)

func apply_velocity(target_speed: float, delta: float) -> void:
	var cam_basis = CAMERA_CONTROLLER.get_horizontal_basis()
	var move_dir = (cam_basis.x * -_input_direction.x) + (cam_basis.z * -_input_direction.y)
	move_dir.y = 0.0
	
	if move_dir.length() > 0.1:
		move_dir = move_dir.normalized()
		_last_movement_direction = move_dir
		velocity.x = move_toward(velocity.x, move_dir.x * target_speed, data.acceleration * delta)
		velocity.z = move_toward(velocity.z, move_dir.z * target_speed, data.acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, data.friction * delta)
		velocity.z = move_toward(velocity.z, 0, data.friction * delta)

	velocity.y += data.gravity * delta
	move_and_slide()

func apply_rotation(delta: float) -> void:
	if _input_mode == InputMode.ACTION:
		var forward = CAMERA_CONTROLLER.get_horizontal_basis().z
		MODEL_CONTROLLER.global_rotation.y = lerp_angle(MODEL_CONTROLLER.global_rotation.y, atan2(forward.x, forward.z), 25.0 * delta)
	elif _input_direction.length() > 0.1:
		MODEL_CONTROLLER.global_rotation.y = lerp_angle(MODEL_CONTROLLER.global_rotation.y, atan2(_last_movement_direction.x, _last_movement_direction.z), 10.0 * delta)

func is_grounded_cone() -> bool:
	var space = get_world_3d().direct_space_state
	for i in range(_cone_ray_count):
		var ray = PhysicsRayQueryParameters3D.create(global_position + Vector3(0, 0.2, 0), global_position + Vector3(0, -_cone_ray_length, 0))
		ray.exclude = [self]
		if space.intersect_ray(ray): return true
	return false

func animation_callback_check_landing() -> void:
	ANIMATION_CONTROLLER.request_landing_state()

# ===
# Private
# ===

func _publish_look_at_target() -> void:
	var result = get_viewport_raycast_data(15.0) 
	var hit_collider = result.get("collider")
	var new_sensor: GazeSensor = null
	
	# Validation
	if hit_collider is GazeSensor:
		var dist = global_position.distance_to(result.get("position", global_position))
		if hit_collider.notify_hover(dist):
			new_sensor = hit_collider

	# State Management
	if new_sensor != _current_hovered_sensor:
		print_debug(new_sensor)
		if _current_hovered_sensor: 
			_current_hovered_sensor.notify_unhover()
		_current_hovered_sensor = new_sensor

	# Event Dispatch
	if _current_hovered_sensor:
		var gaze_target_data = GazeTargetData.new(
			_current_hovered_sensor,
			result.get("position"),
			global_position.distance_to(result.get("position")),
			_current_hovered_sensor.get_current_gaze_color()
		)
		PlayerEvent.GazeTargetUpdated.new(gaze_target_data)
	else:
		PlayerEvent.GazeTargetUpdated.new(null)

func _attempt_interact() -> void:
	# 1. Priority: Precision Gaze (Looking directly at a button/item)
	if _current_hovered_sensor and _current_hovered_sensor.is_interactable:
		var interaction_data = InteractionData.new(self, _current_hovered_sensor.owner)
		WorldEvent.InteractionRequest.new(interaction_data)
		return
	
	# 2. Fallback: Proximity (Standing near an item but not looking at it)
	# This uses the InteractableDetector Area3D
	INTERACTABLE_DETECTOR.interact()

func _setup_loadout() -> void:
	_swap_to_slot(0)

func _update_minimap_icon() -> void:
	if not MINIMAP_ICON: return
	
	var model_yaw = MODEL_CONTROLLER.global_rotation.y
	MINIMAP_ICON.global_rotation.y = model_yaw + PI
	
func _handle_loadout_input() -> void:
	if not _input_enabled: return
	
	if Input.is_action_just_pressed("player_draw_sheath"):
		COMBAT_CONTROLLER.toggle_sheath()
		MODEL_CONTROLLER.set_sheathed(
			data.loadout_data.primary_weapon,
			data.loadout_data.secondary_weapon,
			COMBAT_CONTROLLER.is_sheathed,
			COMBAT_CONTROLLER.current_slot
		)
	elif Input.is_action_just_pressed("player_primary_weapon"):
		_swap_to_slot(0)
	elif Input.is_action_just_pressed("player_secondary_weapon"):
		_swap_to_slot(1)

func _swap_to_slot(slot_index: int) -> void:
	if not data.loadout_data: return
	
	if COMBAT_CONTROLLER.current_slot == slot_index and not COMBAT_CONTROLLER.is_sheathed:
		COMBAT_CONTROLLER.toggle_sheath()
	
		MODEL_CONTROLLER.set_sheathed(
			data.loadout_data.primary_weapon,
			data.loadout_data.secondary_weapon,
			COMBAT_CONTROLLER.is_sheathed,
			COMBAT_CONTROLLER.current_slot
		)
		return
	
	var weapon_data: WeaponData = data.loadout_data.primary_weapon if slot_index == 0 else data.loadout_data.secondary_weapon
	_current_weapon_data = weapon_data
	
	MODEL_CONTROLLER.update_full_loadout(
		data.loadout_data.primary_weapon, 
		data.loadout_data.secondary_weapon, 
		slot_index
	)
	
	COMBAT_CONTROLLER.register_active_weapon(MODEL_CONTROLLER._active_weapon_node, weapon_data, slot_index)

func _update_input_mode() -> void:
	if not _input_enabled: return

	var is_aiming = Input.is_action_pressed("player_aim")
	var is_shooting = Input.is_action_pressed("player_shoot")
	
	if is_aiming != _was_aiming:
		_was_aiming = is_aiming
		if is_aiming:
			WeaponEvent.AimUpdated.new(WeaponEvent.AimState.STARTED)
		else:
			WeaponEvent.AimUpdated.new(WeaponEvent.AimState.FINISHED)
	
	_input_mode = InputMode.ACTION if (is_aiming or is_shooting) else InputMode.ADVENTURE

func _update_animations(delta: float) -> void:
	if not STATE_MACHINE.state: return
	
	var anim_weapon_data = null
	if not COMBAT_CONTROLLER.is_sheathed:
		anim_weapon_data = COMBAT_CONTROLLER.active_weapon_data
	
	ANIMATION_CONTROLLER.update(
		delta, 
		STATE_MACHINE.state.name, 
		int(_input_mode), 
		anim_weapon_data, 
		_was_aiming
	)

func _handle_dev_input():
	if Input.is_action_just_pressed("dev_1"): spawn()
	if Input.is_action_just_pressed("dev_2"): die()

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	# Player Died
	if event is WorldEvent.EntityDied:
		if event.node is Player:
			STATE_MACHINE._transition_to_next_state("Idle")
			spawn()
	
	# Input Toggle
	elif event is PlayerEvent.InputToggled:
		_input_enabled = event.value

# ===
# Signals
# ===
#
#func _on_hurtbox_hit_received(damage_data: DamageData) -> void:
	#if not _hurt_enabled: return
	#
	## Handle Health Reduction
	#data.current_health -= damage_data.amount
	#
	#if data.current_health <= 0:
		#die()
		#return
	#
	## Mercy frames / I-frames
	#_hurt_enabled = false
	#await get_tree().create_timer(0.5).timeout
	#_hurt_enabled = true
