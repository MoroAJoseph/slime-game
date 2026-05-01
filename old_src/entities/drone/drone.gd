class_name Drone
extends CharacterBody3D

@export var data: DroneData

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)

# ===
# Public
# ===

# ===
# Private
# ===

func _on_event(event: Event) -> void:
	pass
