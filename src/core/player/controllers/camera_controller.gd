extends Node3D

@export_group("Config")
@export var _default_boom_length: float = 6.0
@export var _zoomed_boom_length: float = 2.5
@export var _boom_lerp_speed: float = 10.0
@export var _aim_far_distance: float = 1000.0

@export_group("FOV")
@export var _default_fov: float = 75
@export var _zoomed_fov: float = 55.0
@export var _fov_lerp_speed: float = 8.0

@export_group("Offset")
@export var _default_offset: float = 0.3
@export var _aim_offset: float = 1.2
@export var _offset_lerp_speed: float = 8.0

@export_group("Sensitivity")
@export_range(0.01, 1.0) var _mouse_move_sensitivity: float = 0.15
@export_range(0.01, 1.0) var _controller_move_sensitivity: float = 0.15
@export var _ads_sensitivity_multiplier: float = 0.5

@onready var _pivot: Node3D = $Pivot
@onready var _boom: SpringArm3D = $Pivot/Boom
@onready var _camera: Camera3D = $Pivot/Boom/Camera3D

# Movement
var _movement_input: Vector2 = Vector2.ZERO
var _movement_sensitivity: float

# Boom
var _current_boom_length: float
var _target_boom_length: float

# Aiming
var _current_offset: float
var _target_offset: float
var _is_aiming: bool = false


# ===
# Built-In
# ===

func _ready() -> void:
	_current_boom_length = _boom.spring_length
	_target_boom_length = _default_boom_length
	_current_offset = _target_offset
	_camera.position.x = _target_offset
	_camera.fov = _default_fov
	
	EventBus.subscribe(_on_event)

func _input(event: InputEvent) -> void:
	
	# Mouse
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_movement_input = event.relative * _mouse_move_sensitivity
	
	# Controller
	# TODO

func _process(delta: float) -> void:
	# Boom
	_current_boom_length = lerp(_current_boom_length, _target_boom_length, _boom_lerp_speed * delta)
	_boom.spring_length = _current_boom_length
	
	# FOV
	var target_fov = _zoomed_fov if _is_aiming else _default_fov
	_camera.fov = lerp(_camera.fov, target_fov, _fov_lerp_speed * delta)
	
	# Offset
	var offset_side = sign(_target_offset)
	var active_goal = (_aim_offset if _is_aiming else _default_offset) * offset_side
	_current_offset = lerp(_current_offset, active_goal, _offset_lerp_speed * delta)
	_camera.position.x = _current_offset
	
	# Sensitivity
	_movement_sensitivity = 1.0
	if _is_aiming:
		_movement_sensitivity = _ads_sensitivity_multiplier
	
	# Rotation
	_pivot.rotate_y(deg_to_rad(-_movement_input.x * _movement_sensitivity))
	_pivot.rotation.x += deg_to_rad(_movement_input.y * _movement_sensitivity) 
	_pivot.rotation.x = clamp(_pivot.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	_movement_input = Vector2.ZERO

# ===
# Public
# ===

func get_target_position() -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var viewport = get_viewport()
	var screen_center = viewport.get_visible_rect().size / 2
	
	var ray_origin = _camera.project_ray_origin(screen_center)
	var ray_direction = _camera.project_ray_normal(screen_center)
	var ray_end = ray_origin + (ray_direction * _aim_far_distance)
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [owner.get_rid()] 
	
	var result = space_state.intersect_ray(query)
	return result.position if result else ray_end

func get_horizontal_basis() -> Basis:
	return _pivot.global_basis

# ===
# Private
# ===


# ===
# Signals
# ===

func _on_event(event: Event) -> void:
	if event is PlayerEvent.AimUpdated:
		match event.state:
			PlayerEvent.AimState.STARTED:
				_is_aiming = true
				_target_boom_length = _zoomed_boom_length
			PlayerEvent.AimState.FINISHED:
				_is_aiming = false
				_target_boom_length = _default_boom_length
