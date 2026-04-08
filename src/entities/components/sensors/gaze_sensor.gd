class_name GazeSensor
extends Area3D

@export var max_distance: float = 3.0
@export var is_interactable: bool = true
@export var interactable_color: Color = Color.SKY_BLUE
@export var default_color: Color = Color.WHITE

signal hovered()
signal unhovered()

# ===
# Public
# ===

func notify_hover(distance_from_origin: float) -> bool:
	if is_interactable and distance_from_origin <= max_distance:
		hovered.emit()
		return true
	return false

func notify_unhover() -> void:
	unhovered.emit()

func get_current_gaze_color() -> Color:
	return interactable_color if is_interactable else default_color
