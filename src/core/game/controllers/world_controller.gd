extends Node3D

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

func _load_level(path: String, will_replace: bool) -> void:
	if will_replace:
		for child in get_children():
			child.queue_free()
	
	var level_resource = load(path)
	if not level_resource:
		push_error("Could not load path: %s" % path)
		return
	
	var level_instance = level_resource.instantiate()
	add_child(level_instance)
	
	#if level_instance is Level:
		#_initialize_game_level(level_instance)
	
	WorldEvent.LevelLoadNotify.new(level_instance)

func _handle_world_event(event: WorldEvent) -> void:
	if event is WorldEvent.LevelLoadRequest:
		pass

# ===
# Signals
# ===

func _on_event(event: Event) -> void:
	if event is WorldEvent:
		_handle_world_event(event)
