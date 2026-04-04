extends MarginContainer

@onready var _minimap_viewport: SubViewport = $SubViewportContainer/MinimapViewport
@onready var _minimap_camera: MinimapCamera = $SubViewportContainer/MinimapViewport/MinimapCamera

func _ready() -> void:
	EventBus.subscribe(_on_event)

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.GameplayEvent.LevelLoaded:
		await get_tree().process_frame
		
		# Set World3D
		var world_node = get_tree().get_first_node_in_group("world_root")
		if world_node:
			_minimap_viewport.world_3d = world_node.get_world_3d()
		else:
			_minimap_viewport.world_3d = get_viewport().find_world_3d()
			
	if event is EventBus.PlayerEvent.Spawned:
		if _minimap_camera:
			_minimap_camera.assign_target(event.player)
	
	# Example of a toggle event
	if event is EventBus.UIEvent.ToggleMinimapRotation:
		if _minimap_camera:
			_minimap_camera.update_rotate(event.value)
