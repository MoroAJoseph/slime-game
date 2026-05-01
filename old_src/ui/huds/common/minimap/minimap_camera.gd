class_name MinimapCamera
extends Camera3D

@export_group("Tracking")
@export var height: float = 50.0
@export var rotation_smoothness: float = 0.0 
@export var match_target_rotation: bool = true

@export_group("Render Settings")
@export var zoom_size: float = 20.0

var _target: Node3D

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)
	projection = PROJECTION_ORTHOGONAL
	size = zoom_size
	rotation_degrees.x = -90

func _physics_process(_delta: float) -> void:
	if not _target or not is_instance_valid(_target): return
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

# ===
# Private
# ===

func _update_rotate(should_match: bool) -> void:
	match_target_rotation = should_match

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	# Entity Spawned
	if event is WorldEvent.EntitySpawned:
		
		# Player
		if event.node is Player:
			_target = event.node
