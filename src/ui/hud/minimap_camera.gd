class_name MinimapCamera
extends Camera3D

@export_group("Tracking")
@export var height: float = 50.0
## Set to 0.0 for instant snapping, or >0 for smooth rotation
@export var rotation_smoothness: float = 0.0 
@export var match_target_rotation: bool = true

@export_group("Render Settings")
@export var zoom_size: float = 20.0

var _target: Node3D

func _ready() -> void:
	projection = PROJECTION_ORTHOGONAL
	size = zoom_size
	rotation_degrees.x = -90

func _physics_process(_delta: float) -> void:
	if not _target or not is_instance_valid(_target): return
	# Sync position with physics to prevent jitter
	global_position = _target.global_position + Vector3(0, height, 0)

func _process(delta: float) -> void:
	if not _target or not is_instance_valid(_target): return

	if match_target_rotation:
		var forward = Vector3.FORWARD
		if _target.has_method("get_minimap_forward"):
			forward = _target.get_minimap_forward()
		
		var target_yaw = atan2(forward.x, forward.z)
		
		if rotation_smoothness > 0:
			rotation.y = lerp_angle(rotation.y, target_yaw, delta * rotation_smoothness)
		else:
			rotation.y = target_yaw
	else:
		# Static North (World -Z)
		rotation.y = lerp_angle(rotation.y, 0, delta * 10.0)
	
	# Ensure X stays locked at -90
	rotation.x = deg_to_rad(-90)

func assign_target(target: Node3D) -> void:
	_target = target

func update_rotate(should_match: bool) -> void:
	match_target_rotation = should_match
