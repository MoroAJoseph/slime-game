class_name Level
extends Node3D

@export_group("Data")
@export var data: LevelData

@export_group("Scenes")
@export var player_scene: PackedScene
@export var slime_scene: PackedScene

# Hierarchy References
@onready var player_spawn_points: Node3D = $Entities/Player/SpawnPoints
@onready var player_instances: Node3D = $Entities/Player/Instances

@onready var enemy_spawn_points: Node3D = $Entities/Enemy/SpawnPoints
@onready var enemy_instances: Node3D = $Entities/Enemy/Instances

@onready var projectile_container: Node3D = $Projectiles
@onready var fx_container: Node3D = $FX

func _ready() -> void:
	# Initialize LevelData if not provided (e.g., direct scene running)
	if not data:
		data = LevelData.new()
	
	_setup_level()
	
	EventBus.publish(EventBus.GameplayEvent.LevelLoaded.new(data))

func _setup_level() -> void:
	_spawn_player()
	_spawn_enemies()

func _spawn_player() -> void:
	if not player_scene: 
		push_error("Level: player_scene not assigned!")
		return
	
	# Find the first valid PlayerSpawnPoint in the designated folder
	var spawn_node: PlayerSpawnPoint = null
	for child in player_spawn_points.get_children():
		if child is PlayerSpawnPoint:
			spawn_node = child
			break
			
	if not spawn_node:
		push_error("Level: No PlayerSpawnPoint found in Entities/Player/SpawnPoints!")
		return

	# Create a default PlayerData if the marker is empty
	if not spawn_node.player_data:
		spawn_node.player_data = PlayerData.new()
		spawn_node.player_data.name = "Hero"

	var player = player_scene.instantiate() as Player
	
	# Inject data into the player. We duplicate it so runtime 
	# changes (buffs/damage) don't overwrite the original .tres file
	player.data = spawn_node.player_data.duplicate()
	
	# Place the player in the world
	player_instances.add_child(player)
	player.global_transform = spawn_node.global_transform

func _spawn_enemies() -> void:
	if not enemy_spawn_points or not slime_scene: 
		push_warning("Level: EnemySpawnPoints or slime_scene is missing.")
		return
		
	for marker in enemy_spawn_points.get_children():
		if marker is SlimeSpawnPoint:
			_create_slime(marker)

func _create_slime(spawn_point: SlimeSpawnPoint) -> void:
	# Fallback for empty markers
	if not spawn_point.slime_data:
		spawn_point.slime_data = SlimeData.new()
		spawn_point.slime_data.name = "Basic Slime"

	var slime = slime_scene.instantiate()
	
	# IMPORTANT: We duplicate the SlimeData here. 
	# This ensures each slime has its OWN unique health/stats logic.
	if "data" in slime:
		slime.data = spawn_point.slime_data.duplicate()
		
	# Add to instances folder and copy position/rotation from the marker
	enemy_instances.add_child(slime)
	slime.global_transform = spawn_point.global_transform
	
	# Track enemies for level clear logic
	data.enemies_alive += 1
	
	# Connect to the death signal to trigger progress
	if slime.has_signal("died"):
		slime.died.connect(_on_enemy_died)

func _on_enemy_died() -> void:
	data.enemies_alive -= 1
	
	if data.enemies_alive <= 0:
		_on_level_cleared()

func _on_level_cleared() -> void:
	print("Level Cleared! Current Floor: ", -1)
	# Here you could trigger a portal, show a victory screen, etc.
