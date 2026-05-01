@tool
class_name PlayerData
extends Resource

@export_group("Movement")
@export var walk_speed: float = 5.0
@export var run_speed: float = 12.0
@export var crouch_walk_speed: float = 3.0
@export var jump_force: float = 12.0
@export var acceleration: float = 80.0
@export var friction: float = 60.0
@export var gravity: float = -30.0

@export_group("Resources")
@export var energy_current: float = 100
@export var energy_maximum: float = 100
