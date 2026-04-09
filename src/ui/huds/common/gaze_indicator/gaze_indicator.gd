extends Panel

@export var default_color: Color = Color.WHITE
@export var default_size: Vector2 = Vector2(8, 8)
@export var interact_size: Vector2 = Vector2(12, 12)

# ===
# Built-In
# ===

func _ready() -> void:
	pivot_offset = custom_minimum_size / 2.0
	_update_dot(default_color, default_size)
	EventBus.subscribe(_on_event)

# ===
# Private
# ===

func _update_dot(target_color: Color, target_size: Vector2) -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", target_color, 0.1)
	tween.tween_property(self, "custom_minimum_size", target_size, 0.1)
	tween.tween_property(self, "pivot_offset", target_size / 2.0, 0.1)

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	if event is PlayerEvent.GazeTargetUpdated:
		if event.data:
			_update_dot(event.data.ui_color, interact_size)
		else:
			_update_dot(default_color, default_size)
