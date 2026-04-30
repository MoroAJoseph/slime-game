class_name PlayerCameraController
extends Node3D

@export_group("Config")
@export var _default_boom_length: float = 6.0
@export var _zoomed_boom_length: float = 2.5
@export var _boom_lerp_speed: float = 10.0
@export var _aim_far_distance: float = 1000.0

@export_group("FOV")
@export var _default_fov: float = 75.0
@export var _zoomed_fov: float = 55.0
@export var _fov_lerp_speed: float = 12.0

@export_group("Shoulder Offset")
@export var _shoulder_offset_amount: float = 0.3
@export var _aim_shoulder_offset: float = 1.2
@export var _offset_lerp_speed: float = 8.0

@export_group("Aim Sensitivity")
@export var _ads_sensitivity_multiplier: float = 0.5 # Lower = slower move while aiming

@onready var _pivot: Node3D = $Pivot
@onready var _boom: SpringArm3D = $Pivot/Boom
@onready var _camera: Camera3D = $Pivot/Boom/Camera3D

var _current_boom_length: float
var _target_boom_length: float

var _current_shoulder_offset: float = 0.0
var _target_shoulder_offset: float = 0.3
var _is_aiming: bool = false

# ===
# Built-In
# ===

func _ready() -> void:
	_current_boom_length = _boom.spring_length
	_target_boom_length = _default_boom_length
	_current_shoulder_offset = _target_shoulder_offset
	_camera.position.x = _current_shoulder_offset
	_camera.fov = _default_fov
	
	EventBus.subscribe(_on_event)

func _process(delta: float) -> void:
	# Lerp Boom Length
	_current_boom_length = lerp(_current_boom_length, _target_boom_length, _boom_lerp_speed * delta)
	_boom.spring_length = _current_boom_length
	
	# Lerp FOV
	var target_fov = _zoomed_fov if _is_aiming else _default_fov
	_camera.fov = lerp(_camera.fov, target_fov, _fov_lerp_speed * delta)
	
	# Lerp Shoulder Offset
	var side_mult = sign(_target_shoulder_offset)
	var active_goal = (_aim_shoulder_offset if _is_aiming else _shoulder_offset_amount) * side_mult
	
	_current_shoulder_offset = lerp(_current_shoulder_offset, active_goal, _offset_lerp_speed * delta)
	_camera.position.x = _current_shoulder_offset

# ===
# Public
# ===

func swap_shoulder() -> void:
	if _target_shoulder_offset > 0:
		_target_shoulder_offset = -_shoulder_offset_amount
	else:
		_target_shoulder_offset = _shoulder_offset_amount

func get_horizontal_basis() -> Basis:
	return _pivot.global_basis

func rotate_camera(input: Vector2) -> void:
	# Apply sensitivity reduction if aiming
	var sensitivity = 1.0
	if _is_aiming:
		sensitivity = _ads_sensitivity_multiplier
		
	_pivot.rotate_y(deg_to_rad(-input.x * sensitivity))
	_pivot.rotation.x += deg_to_rad(input.y * sensitivity) 
	_pivot.rotation.x = clamp(_pivot.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func get_aim_target() -> Vector3:
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

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	if event is WeaponEvent.AimUpdated:
		match event.state:
			WeaponEvent.AimState.STARTED:
				_is_aiming = true
				_target_boom_length = _zoomed_boom_length
			WeaponEvent.AimState.FINISHED:
				_is_aiming = false
				_target_boom_length = _default_boom_length
