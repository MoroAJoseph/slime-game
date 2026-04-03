class_name HUD
extends CanvasLayer

@export var MINIMAP_CAMERA: MinimapCamera

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.PlayerEvent.Spawned:
		MINIMAP_CAMERA.assign_target(event.player)
