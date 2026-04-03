class_name GunCombatData
extends Resource

enum FireMode { SEMI_AUTO, BURST, FULL_AUTO }

@export_group("Combat")
@export var name: String = "Rifle"
@export var fire_mode: FireMode = FireMode.FULL_AUTO
@export var fire_rate: float = 15 # shots per second
@export var mag_capacity: int = 30
@export var reload_time: float = 2.0
@export var base_damage: float = 5.0
@export_range(0.0, 1.0) var crit_chance: float = 0.25
