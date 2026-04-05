class_name ElevatorTransitData
extends Resource

@export var target_floor_index: int
@export var target_position: Vector3

func _init(p_index: int = 0, p_pos: Vector3 = Vector3.ZERO) -> void:
	target_floor_index = p_index
	target_position = p_pos
