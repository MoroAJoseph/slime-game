extends Panel

@export var default_color: Color = Color.WHITE
@export var interact_color: Color = Color.SKY_BLUE
@export var enemy_color: Color = Color.CRIMSON
@export var default_size: Vector2 = Vector2(8, 8)
@export var interact_size: Vector2 = Vector2(12, 12)

# ===
# Built-In
# ===

func _ready() -> void:
	pivot_offset = custom_minimum_size / 2.0
	set_world()
	EventBus.subscribe(_on_event)

# ===
# Public
# ===

func set_world() -> void:
	_update_dot(default_color, default_size)

func set_interact() -> void:
	_update_dot(interact_color, interact_size)

func set_enemy() -> void:
	_update_dot(enemy_color, default_size)

# ===
# Private
# ===

func _process_ray_result(hit: Dictionary) -> void:
	# No Hit
	if hit.is_empty():
		set_world()
		return
	
	var layer = hit.get("layer", 0)
	
	if layer & 128:   # Layer 8 (UI)
		set_interact()
	elif layer & 4:   # Layer 3 (Enemy)
		set_enemy()
	else:             # Layer 1 (World) or others
		set_world()

func _update_dot(target_color: Color, target_size: Vector2) -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", target_color, 0.1)
	tween.tween_property(self, "custom_minimum_size", target_size, 0.1)
	tween.tween_property(self, "pivot_offset", target_size / 2.0, 0.1)

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.PlayerEvent.LookAtTargetUpdated:
		_process_ray_result(event.result)
