@tool
class_name PlayerData
extends EntityData

@export_group("Health")
@export var current_health: float = 100.0
@export var max_health: float = 100.0

@export_group("Movement")
@export var walk_speed: float = 5.0
@export var run_speed: float = 12.0
@export var jump_force: float = 12.0
@export var acceleration: float = 80.0
@export var friction: float = 60.0
@export var gravity: float = -30.0

@export_group("Equipment")
@export var loadout_data: PlayerLoadoutData
