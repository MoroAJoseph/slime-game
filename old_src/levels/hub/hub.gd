class_name Hub
extends Level

var data: HubData

@onready var _player_spawn_point: PlayerSpawnPoint = $PlayerSpawnPoint
@onready var _entities_container: Node3D = $Entities

# === 
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)
	_spawn_player.call_deferred()

# ===
# Private
# ===

func _spawn_player() -> void:
	if not _player_spawn_point: return
	
	var player_data: PlayerData = _player_spawn_point.player_data
	var player = load(Constants.ENTITY_PLAYER_SCENE_PATH).instantiate() as Player
	
	player.data = player_data
	player.global_transform = _player_spawn_point.global_transform
	
	_entities_container.add_child(player)
	
	WorldEvent.EntitySpawned.new(player)

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	pass
