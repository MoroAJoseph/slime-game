class_name LevelData
extends Resource

# Settings
@export var level_name: String = "Slime Pits"
@export var target_enemy_count: int = 20
@export var difficulty_scale: float = 1.0

# Live Tracking (Reset every level)
var enemies_alive: int = 0
var enemies_remaining_to_spawn: int = 0
var chests_spawned: int = 0
var is_boss_level: bool = false

# Spawn Point Cache
var enemy_spawn_points: Array[Vector3] = []
var chest_spawn_points: Array[Vector3] = []
var player_spawn_point: Vector3 = Vector3.ZERO
