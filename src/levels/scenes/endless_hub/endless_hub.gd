class_name EndlessHub
extends Level

var data: EndlessHubData

@export var _player_scene: PackedScene

@onready var _player_spawn_point: PlayerSpawnPoint = $PlayerSpawnPoint
@onready var _entities_container: Node3D = $Entities
@onready var _projectile_container: Node3D = $Projectiles
@onready var _fx_container: Node3D = $FX

# === 
# Built-In
# ===

func _ready() -> void:
	if not _player_scene:
		push_error("EndlessHub: Player Scene is missing in Inspector!")
		return

	_spawn_player()

	EventBus.publish(EventBus.GameplayEvent.LevelLoaded.new(data))

# ===
# Private
# ===

func _spawn_player() -> void:
	var player_data: PlayerData
	
	if _player_spawn_point and _player_spawn_point.player_data:
		player_data = _player_spawn_point.player_data
	else:
		print_debug("EndlessHub: No spawn data found, creating default PlayerData")
		player_data = PlayerData.new()
		
	if not player_data.loadout_data:
		print_debug("No loadout")
		player_data.loadout_data = PlayerLoadoutData.new()

	var player = _player_scene.instantiate() as Player
	
	player.data = player_data
	
	_entities_container.add_child(player)
	
	if _player_spawn_point:
		player.global_transform = _player_spawn_point.global_transform
	
	EventBus.publish(EventBus.PlayerEvent.Spawned.new(player))
