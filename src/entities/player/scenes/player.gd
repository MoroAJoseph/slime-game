class_name Player
extends CharacterBody3D

@export var data: PlayerData
@export_range(0.01, 1.0) var _mouse_sensitivity: float = 0.15

@onready var MINIMAP_ICON: Sprite3D = $MinimapIcon
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
	
	if Input.is_action_just_pressed("player_reload"):
		COMBAT_CONTROLLER.request_reload()

	_handle_loadout_input()
	_update_animations(delta)
	_update_minimap_icon()

func _physics_process(_delta: float) -> void:
	_input_direction = Input.get_vector(
		"player_move_left", "player_move_right", 
		"player_move_forward", "player_move_backward"
	)

# ===
# Local
# ===

func _setup_loadout() -> void:
	_current_weapon_data = data.loadout_data.primary_weapon
	_swap_to_slot(0)

func _update_minimap_icon() -> void:
	if not MINIMAP_ICON: return
	
	var model_yaw = MODEL_CONTROLLER.global_rotation.y
	MINIMAP_ICON.global_rotation.y = model_yaw + PI
	
func _handle_loadout_input() -> void:
	if Input.is_action_just_pressed("player_primary_weapon"):
		_swap_to_slot(0)
	elif Input.is_action_just_pressed("player_secondary_weapon"):
		_swap_to_slot(1)

func _swap_to_slot(slot_index: int) -> void:
	if not data.loadout_data: return
	
	var weapon_res: WeaponData = data.loadout_data.primary_weapon if slot_index == 0 else data.loadout_data.secondary_weapon
	
	# Update visual model and combat logic
	var weapon_node = MODEL_CONTROLLER.equip_weapon(weapon_res)
	COMBAT_CONTROLLER.register_active_weapon(weapon_node, weapon_res)

func _update_input_mode() -> void:
	var is_aiming = Input.is_action_pressed("player_aim")
	var is_shooting = Input.is_action_pressed("player_shoot")
	
	if is_aiming != _was_aiming:
		_was_aiming = is_aiming
		if is_aiming:
			EventBus.publish(EventBus.PlayerEvent.AimStarted.new(EventBus.PlayerEvent.AimStarted.Type.HIP))
		else:
			EventBus.publish(EventBus.PlayerEvent.AimFinished.new())
	
	_input_mode = InputMode.ACTION if (is_aiming or is_shooting) else InputMode.ADVENTURE

func _update_animations(delta: float) -> void:
	if not STATE_MACHINE.state: return
	ANIMATION_CONTROLLER.update(
		delta, 
		STATE_MACHINE.state.name, 
		int(_input_mode), 
		COMBAT_CONTROLLER.active_weapon_data, 
		_was_aiming
	)

func get_minimap_forward() -> Vector3:
	var cam_forward = -CAMERA_CONTROLLER.get_horizontal_basis().z
	cam_forward.y = 0
	return cam_forward.normalized()

func spawn() -> void:
	_hurt_enabled = false
	MODEL_CONTROLLER.reset_visuals()
	MODEL_CONTROLLER.set_spawn_visuals(true)
	
	# 2. Animate the "Scanning" line from feet to head
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
			EventBus.publish(EventBus.PlayerEvent.Spawned.new(self))
	)

func die() -> void:
	_hurt_enabled = false
	STATE_MACHINE._transition_to_next_state("Dead")
	MODEL_CONTROLLER.trigger_death_visuals()
	await get_tree().create_timer(3.0).timeout
	EventBus.publish(EventBus.PlayerEvent.Died.new())

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
		var angle = float(i) / _cone_ray_count * TAU
		var ray = PhysicsRayQueryParameters3D.create(global_position + Vector3(0, 0.2, 0), global_position + Vector3(0, -_cone_ray_length, 0))
		ray.exclude = [self]
		if space.intersect_ray(ray): return true
	return false

func animation_callback_check_landing() -> void:
	ANIMATION_CONTROLLER.request_landing_state()

func _handle_dev_input():
	if Input.is_action_just_pressed("dev_1"): spawn()
	if Input.is_action_just_pressed("dev_2"): die()

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.PlayerEvent.Died:
		STATE_MACHINE._transition_to_next_state("Idle")
		spawn()

# ===
# Signals
# ===

func _on_hurtbox_hit_received(damage_data: DamageData) -> void:
	if not _hurt_enabled: return
	
	# Handle Health Reduction
	data.current_health -= damage_data.amount
	
	if data.current_health <= 0:
		die()
		return
	
	# Mercy frames / I-frames
	_hurt_enabled = false
	await get_tree().create_timer(0.5).timeout
	_hurt_enabled = true
