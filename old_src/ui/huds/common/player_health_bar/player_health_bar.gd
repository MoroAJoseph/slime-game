extends MarginContainer

@onready var _bar: TextureProgressBar = $Bar

# ===
# Built-In
# ===

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_3"):
		_update_current(_bar.value + 10)
	elif event.is_action_pressed("dev_4"):
		_update_current(_bar.value - 10)

# ===
# Private
# ===

func _setup(current: float, maximum: float) -> void:
	_bar.max_value = maximum
	_bar.value = current

func _update_current(value: float) -> void:
	var tween = create_tween()
	tween.tween_property(_bar, "value", value, 0.2).set_ease(Tween.EASE_OUT)

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	if event is WorldEvent.EntitySpawned:
		if event.node is Player:
			var player: Player = event.node
			var data: PlayerData = player.data
			_setup(data.current_health, data.max_health)
	
	if event is PlayerEvent.HealthUpdated:
		_update_current(event.current)
