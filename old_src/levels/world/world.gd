class_name World
extends Level

var data: WorldData

@onready var _player_scene = preload(Constants.ENTITY_PLAYER_SCENE_PATH)
@onready var _slime_scene = preload(Constants.ENTITY_SLIME_SCENE_PATH)

@onready var _entities_container: Node3D = $Entities
@onready var _slime_spawn_points: Node3D = _entities_container.get_node("Slimes/SpawnPoints")
@onready var _slime_instances: Node3D = _entities_container.get_node("Slimes/Instances")
@onready var _player_spawn_points: Node3D = _entities_container.get_node("Player/SpawnPoints")
@onready var _player_instances: Node3D = _entities_container.get_node("Player/Instances")
@onready var _projectiles_container: Node3D = $Projectiles

# === 
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)
	_spawn_player.call_deferred()
	_spawn_slimes.call_deferred()

# ===
# Private
# ===

func _spawn_player() -> void:
	var spawn_point: PlayerSpawnPoint = _player_spawn_points.get_child(0)
	if not spawn_point: return
	
	var player = _player_scene.instantiate() as Player
	
	player.data = spawn_point.player_data
	
	_player_instances.add_child(player)
	
	player.global_transform = spawn_point.global_transform
	
	WorldEvent.EntitySpawned.new(player)

func _spawn_slimes() -> void:
	for spawn_point in _slime_spawn_points.get_children():
		if not is_instance_of(spawn_point, SlimeSpawnPoint): return
		
		var slime = _slime_scene.instantiate() as Slime
	
		slime.data = spawn_point.slime_data
		
		_slime_instances.add_child(slime)
		
		slime.global_transform = spawn_point.global_transform
		
		WorldEvent.EntitySpawned.new(slime)


# ===
# Events
# ===

func _on_event(event: Event) -> void:
	if event is WorldEvent.EntityDied:
		if event.node is Slime:
			var position: Vector3 = event.node.global_position
			print_debug(randi_range(0, 100))
