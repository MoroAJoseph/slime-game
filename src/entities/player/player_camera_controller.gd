class_name PlayerCameraController
extends Node3D

@export_group("Config")
@export var _default_boom_length: float = 6.0
@export var _zoomed_boom_length: float = 4.0
@export var _boom_lerp_speed: float = 10.0
@export var _aim_far_distance: float = 1000.0

@onready var PIVOT: Node3D = $Pivot
@onready var BOOM: SpringArm3D = $Pivot/Boom
@onready var CAMERA: Camera3D = $Pivot/Boom/Camera3D

var _current_boom_length: float
var _target_boom_length: float

# ===
# Built-In
# ===

func _ready() -> void:
	_current_boom_length = BOOM.spring_length
	_target_boom_length = _default_boom_length
	EventBus.subscribe(_on_event)


func _process(delta: float) -> void:
	_current_boom_length = lerp(_current_boom_length, _target_boom_length, _boom_lerp_speed * delta)
	BOOM.spring_length = _current_boom_length


# ===
# Local
# ===

func get_horizontal_basis() -> Basis:
	return PIVOT.global_basis

func rotate_camera(input: Vector2, _is_combat: bool, _delta: float) -> void:
	PIVOT.rotate_y(deg_to_rad(-input.x))
	PIVOT.rotation.x += deg_to_rad(input.y) 
	PIVOT.rotation.x = clamp(PIVOT.rotation.x, deg_to_rad(-60), deg_to_rad(30))

func get_aim_target() -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var viewport = get_viewport()
	var screen_center = viewport.get_visible_rect().size / 2
	
	var ray_origin = CAMERA.project_ray_origin(screen_center)
	var ray_direction = CAMERA.project_ray_normal(screen_center)
	var ray_end = ray_origin + (ray_direction * _aim_far_distance)
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [owner.get_rid()] 
	
	var result = space_state.intersect_ray(query)
	return result.position if result else ray_end

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.PlayerEvent.AimStarted:
		if event.type == event.Type.HIP:
			_target_boom_length = _zoomed_boom_length
	if event is EventBus.PlayerEvent.AimFinished:
		_target_boom_length = _default_boom_length
