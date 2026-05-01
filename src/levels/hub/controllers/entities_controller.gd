extends Node3D

@onready var _player_spawns: Node3D = $Player/Spawns
@onready var _player_instances: Node3D = $Player/Instances

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)

# ===
# Private
# ===

func _handle_world_event(event: WorldEvent) -> void:
	if event is WorldEvent.EntitySpawnRequest:
		pass

func _spawn_player() -> void:
	var data: PlayerData 

# ===
# Signals
# ===

func _on_event(event: Event) -> void:
	if event is WorldEvent:
		_handle_world_event(event)
