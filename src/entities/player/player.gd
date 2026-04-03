class_name Player
extends CharacterBody3D

@export var data: PlayerData
@export_range(0.01, 1.0) var _mouse_sensitivity: float = 0.15

# Children
@onready var MODEL_CONTROLLER: PlayerModelController = $ModelController
@onready var STATE_MACHINE: StateMachine = $StateMachine
@onready var CAMERA_CONTROLLER: CameraController = $CameraController
@onready var ANIMATION_CONTROLLER: PlayerAnimationController = $AnimationController

enum InputMode { ADVENTURE, ACTION }
enum WeaponSelect { UNARMED, RIFLE, SWORD }

var _input_direction: Vector2 = Vector2.ZERO
var _camera_input: Vector2 = Vector2.ZERO
var _last_movement_direction: Vector3 = Vector3.BACK
var _input_mode: InputMode = InputMode.ADVENTURE
var _weapon_selected: WeaponSelect = WeaponSelect.RIFLE
var _was_aiming: bool = false
var _hurt_enabled: bool = false
var _death_timer_duration: float = 3.0
var _hurt_timer_duration: float = 0.5
var _cone_ray_count: int = 8
var _cone_ray_length: float = 0.3


# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)
	MODEL_CONTROLLER.setup_weapons(data.loadout_data)
	spawn()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_camera_input = event.relative * _mouse_sensitivity

func _process(delta: float) -> void:
	if get_tree().paused: return
	
	# DEV INPUTS
	if Input.is_action_just_pressed("dev_1"):
		spawn()
	if Input.is_action_just_pressed("dev_2"):
		die()

	# Aiming
	var is_aiming = Input.is_action_pressed("player_aim")
	if is_aiming and not _was_aiming:
		_was_aiming = true
		EventBus.publish(EventBus.PlayerEvent.AimStarted.new(EventBus.PlayerEvent.AimStarted.Type.HIP))
	elif not is_aiming and _was_aiming:
		_was_aiming = false
		EventBus.publish(EventBus.PlayerEvent.AimFinished.new())
	
	var is_attempting_shoot = Input.is_action_pressed("player_shoot")
	_input_mode = InputMode.ACTION if is_aiming or is_attempting_shoot else InputMode.ADVENTURE

	CAMERA_CONTROLLER.rotate_camera(_camera_input, _input_mode == InputMode.ACTION, delta)
	_camera_input = Vector2.ZERO

	_handle_combat_input()
	_handle_general_input()
	apply_rotation(delta)

	if STATE_MACHINE.state:
		var weapon_str = WeaponSelect.keys()[_weapon_selected].capitalize()
		ANIMATION_CONTROLLER.update(delta, STATE_MACHINE.state.name, int(_input_mode), weapon_str, is_aiming)

func _physics_process(delta: float) -> void:
	_input_direction = Input.get_vector(
		"player_move_left", "player_move_right", 
		"player_move_forward", "player_move_backward"
	)

# ===
# Local
# ===

func spawn() -> void:
	RenderingServer.global_shader_parameter_set("player_spawn_height", -0.1)
	MODEL_CONTROLLER.reset_visuals()
	MODEL_CONTROLLER.set_spawn_visuals(true)
	
	var tween = create_tween()
	tween.tween_method(
		func(val: float): RenderingServer.global_shader_parameter_set("player_spawn_height", val),
		-0.1, 
		2.2, 
		6.0
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(
		func(): 
			MODEL_CONTROLLER.set_spawn_visuals(false)
			EventBus.publish(EventBus.PlayerEvent.Spawned.new(self))
			_hurt_enabled = true
	)

func die() -> void:
	_hurt_enabled = false
	STATE_MACHINE._transition_to_next_state("Dead") 
	MODEL_CONTROLLER.trigger_death_visuals()
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(
		func():
			EventBus.publish(EventBus.PlayerEvent.Died.new())
	)
	await timer.timeout
	

# --- Movement & Rotation Logic ---
func apply_velocity(target_speed: float, delta: float) -> void:
	var cam_basis = CAMERA_CONTROLLER.get_horizontal_basis()
	
	# RESTORED: Matches your original (cam_basis.x * -_input_direction.x) logic
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
	var pos = global_transform.origin
	for i in range(_cone_ray_count):
		var angle = float(i)/_cone_ray_count*TAU
		var dir = Vector3(cos(angle), 0, sin(angle)).rotated(Vector3.UP, rotation.y).normalized()
		var from_pos = pos + Vector3(0,0.2,0)
		var to_pos = from_pos + Vector3(0,-_cone_ray_length,0)
		var ray_params = PhysicsRayQueryParameters3D.new()
		ray_params.from = from_pos
		ray_params.to = to_pos
		ray_params.exclude = [self]
		if space.intersect_ray(ray_params):
			return true
	return false

# --- Combat Helpers ---
func _handle_combat_input() -> void:
	if _input_mode != InputMode.ACTION: return
	var gun = MODEL_CONTROLLER.get_current_gun()
	if not gun: return
	var fire_mode = gun.data.fire_mode if gun.data else GunData.FireMode.SEMI_AUTO
	if fire_mode == GunData.FireMode.FULL_AUTO:
		if Input.is_action_pressed("player_shoot"): _trigger_gun(gun)
	else:
		if Input.is_action_just_pressed("player_shoot"): _trigger_gun(gun)

func _handle_general_input() -> void:
	var gun = MODEL_CONTROLLER.get_current_gun()
	if gun and Input.is_action_just_pressed("player_reload"):
		gun.reload()

func _trigger_gun(gun: Gun) -> void:
	var target_3d_point = CAMERA_CONTROLLER.get_aim_target()
	var barrel_pos = gun._bullet_projectile_spawn_node.global_position
	gun.shoot((target_3d_point - barrel_pos).normalized())

# --- Animation Player Callbacks ---
func animation_callback_check_landing() -> void:
	ANIMATION_CONTROLLER.request_landing_state()

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
	_hurt_enabled = false
	print_debug("Damage data: {0}".format([damage_data]))
	# TODO: Take damage
	
	# TODO: Check if dead
	var did_die: bool = false
	if did_die: 
		die()
		return
	
	var timer = get_tree().create_timer(_hurt_timer_duration)
	timer.timeout.connect(
		func():
			_hurt_enabled = true
	)
	await timer.timeout
