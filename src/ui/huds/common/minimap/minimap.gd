extends MarginContainer

@onready var VIEWPORT: SubViewport = %SubViewport

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.GameplayEvent.LevelLoaded:
		await get_tree().process_frame
		
		# Set World3D
		var world_node = get_tree().get_first_node_in_group("world_root")
		if world_node:
			VIEWPORT.world_3d = world_node.get_world_3d()
		else:
			VIEWPORT.world_3d = get_viewport().find_world_3d()
	
