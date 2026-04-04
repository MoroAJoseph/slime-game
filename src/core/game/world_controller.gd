class_name WorldController
extends Node

@export_file var _title_level_path: String

@onready var _world_node: Node3D = $World

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)

# ===
# Local
# ===

func _load_scene(path: String) -> void:
	for child in _world_node.get_children():
		child.queue_free()
	
	var map_res = load(path)
	if not map_res:
		push_error("WorldController: Could not load path: %s" % path)
		return
		
	var map_instance = map_res.instantiate()
	_world_node.add_child(map_instance)
	
	if map_instance is Level:
		_initialize_game_level(map_instance)
		EventBus.publish(EventBus.GameplayEvent.LevelLoaded.new(map_instance.data))
	else:
		EventBus.publish(EventBus.GameplayEvent.TitleLoaded.new())

func _initialize_game_level(level_node: Level) -> void:
	var level_data: LevelData
	
	if level_node is SandboxLevel:
		level_data = LevelData.new()
		level_data.name = "Sandbox"
		
	elif level_node is EndlessHub:
		level_data = EndlessHubData.new()
		level_data.name = "Endless Hub"
		
	else:
		level_data = LevelData.new()
		level_data.difficulty_scale = 1
		level_data.target_enemy_count = 15

	level_node.data = level_data

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.GameplayEvent.RequestLoadLevel:
		_load_scene(event.path)
	elif event is EventBus.GameplayEvent.RequestLoadTitle:
		_load_scene(_title_level_path)
