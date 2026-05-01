class_name Player
extends CharacterBody3D

@export var _data: PlayerData

@onready var _state_machine: StateMachine = %StateMachine
@onready var _model: Node3D = %Model
@onready var _camera: Node3D = %Camera
@onready var _animation: Node = %Animation

enum MovementMode { ADVENTURE, ACTION }

# Input
var _can_input: bool = false
var _input_direction: Vector2 = Vector2.ZERO
var _is_aiming: bool = false
var _is_attacking: bool = false

# Movement
var _can_move: bool = false
var _movement_mode: MovementMode = MovementMode.ADVENTURE
var _last_movement_direction: Vector3 = Vector3.BACK

# Gaze
var _was_aiming: bool = false

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)

func _process(delta: float) -> void:
	# Input
	_input_direction = Input.get_vector(
			"player_move_left", "player_move_right", 
			"player_move_forward", "player_move_backward"
		) if _can_input else Vector2.ZERO
	
	_is_aiming = Input.is_action_pressed("player_aim")
	_is_attacking = Input.is_action_pressed("player_attack")
	
	# Movement
	_update_movement_mode()
	
	# Rotation
	_apply_rotation(delta)
	
	# Gaze
	
	# Animation
	_animation.update(
		delta, 
		_state_machine.state.name, 
		int(_movement_mode), 
		null, 
		_was_aiming
	)
	
	# Minimap Icon

# ===
# Public
# ===

func get_data() -> PlayerData:
	return _data

func get_input_direction() -> Vector2:
	return _input_direction

func apply_velocity(target_speed: float, delta: float) -> void:
	var camera_basis = _camera.get_horizontal_basis()
	var move_direction = (camera_basis.x * -_input_direction.x) + (camera_basis.z * -_input_direction.y)
	move_direction.y = 0.0
	
	if move_direction.length() > 0.1:
		move_direction = move_direction.normalized()
		_last_movement_direction = move_direction
		velocity.x = move_toward(velocity.x, move_direction.x * target_speed, _data.acceleration * delta)
		velocity.z = move_toward(velocity.z, move_direction.z * target_speed, _data.acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, _data.friction * delta)
		velocity.z = move_toward(velocity.z, 0, _data.friction * delta)

	velocity.y += _data.gravity * delta
	move_and_slide()


# ===
# Private
# ===

func _apply_rotation(delta: float) -> void:
	if _movement_mode == MovementMode.ACTION:
		var forward = _camera.get_horizontal_basis().z
		_model.global_rotation.y = lerp_angle(_model.global_rotation.y, atan2(forward.x, forward.z), 25.0 * delta)
	elif _input_direction.length() > 0.1:
		_model.global_rotation.y = lerp_angle(_model.global_rotation.y, atan2(_last_movement_direction.x, _last_movement_direction.z), 10.0 * delta)

func _spawn() -> void:
	_can_move = true
	_model.reset_visuals()
	_model.set_spawn_visuals(true)
	# TODO Damage disabled
	
	var tween = create_tween()
	tween.tween_method(
		_model.update_spawn_visual, 
		-0.2, # Start slightly below feet
		2.0,  # End above head
		2.0   # Duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(
		func(): 
			_model.set_spawn_visuals(false)
			# TODO Damage enabled
	)

func _die() -> void:
	# TODO
	_can_move = false

func _update_movement_mode() -> void:
	if _is_aiming != _was_aiming:
		_was_aiming = _is_aiming
		if _is_aiming:
			PlayerEvent.AimUpdated.new(PlayerEvent.AimState.STARTED)
		else:
			PlayerEvent.AimUpdated.new(PlayerEvent.AimState.FINISHED)
	
	_movement_mode = MovementMode.ACTION if (_is_aiming or _is_attacking) else MovementMode.ADVENTURE

# ===
# Signals
# ===

func _on_event(event: Event) -> void:
	# Kill
	if event is WorldEvent.EntityKillRequest:
		if event.node == self:
			_die()
	
	# Die
	elif event is WorldEvent.EntityDieNotify:
		if event.node == self:
			_state_machine.transition_to("Idle")
			_spawn()
