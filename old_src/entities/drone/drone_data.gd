class_name DroneData
extends Resource

enum Mode { SENTRY, TRANSPORT, FOLLOW, CHARGE, IDLE }

@export var current_mode: Mode = Mode.IDLE
@export var inventory: Array[ItemData]
@export var max_carry_weight: float = 5.0
@export var max_range: float = 50.0 # Meters
@export var transport_movement_speed: float = 5.0
@export var max_battery_capacity: float = 100.0
@export var current_battery_capacity: float = 100.0
