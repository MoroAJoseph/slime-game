class_name BulletData
extends Resource

@export_group("Damage")
@export var damage: float = 0.0
@export var crit_multiplier: float = 2.0
@export var armor_penetration: float = 0.0

@export_group("Physics")
@export var speed: float = 60.0
@export var gravity_scale: float = 0.0 # For bullet drop later
@export var lifetime: float = 5.0

# Store a reference to the gun's data for FX or logging
var source_gun_data: GunData
