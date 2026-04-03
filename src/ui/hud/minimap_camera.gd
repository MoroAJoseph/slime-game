class_name MinimapCamera
extends Camera3D

var _target: Node3D
var _offset: Vector3
var _match_target_rotation: bool
var _initial_rotation: float

# TODO: Assign and create minimap render layer for minimap assets

# ===
# Built-In
# ===

func _ready() -> void:
	# TODO: Set initial rotation here
	pass

func _process(delta: float) -> void:
	if _target:
		global_position = _target.global_position + _offset
	# TODO: Rotate with the target's forward direction if match target rotation true, else correct camera rotation to default

# ===
# Local
# ===

func assign_target(target: Node3D) -> void:
	_target = target
	_offset = global_position - target.global_position

func update_rotate(match_target: bool) -> void:
	_match_target_rotation = match_target
