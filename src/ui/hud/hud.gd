class_name HUD
extends CanvasLayer


# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	pass
