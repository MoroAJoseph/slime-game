class_name EndlessHub
extends Level

var data: EndlessHubData

@onready var _player_scene = preload(Constants.ENTITY_PLAYER_SCENE_PATH)

@onready var PLAYER_SPAWN_POINT: PlayerSpawnPoint = $PlayerSpawnPoint
@onready var ENTITIES_CONTAINER: Node3D = $Entities
@onready var PROJECTILES_CONTAINER: Node3D = $Projectiles

# === 
# Built-In
# ===

func _ready() -> void:
	_spawn_player.call_deferred()
	EventBus.subscribe(_on_event)

# ===
# Private
# ===

func _spawn_player() -> void:
	if not PLAYER_SPAWN_POINT: return
	
	var player_data: PlayerData = PLAYER_SPAWN_POINT.player_data
	var player = _player_scene.instantiate() as Player
	
	player.data = player_data
	
	ENTITIES_CONTAINER.add_child(player)
	
	player.global_transform = PLAYER_SPAWN_POINT.global_transform
	
	WorldEvent.EntitySpawned.new(player)

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	pass
