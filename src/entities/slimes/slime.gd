class_name Slime
extends CharacterBody3D

signal died

@onready var _model_controller: SlimeModelController = $ModelController
@onready var _health_bar_3D: HealthBar3D = $HealthBar3D
@onready var _damage_sensor: DamageSensor = $DamageSensor

var data: SlimeData
var current_health: float
var is_dead: bool = false

# ===
# Built-In
# ===

func _ready() -> void:
	if data:
		current_health = data.max_health
		_health_bar_3D.setup(data.max_health)
		_model_controller.apply_slime_color(data.slime_color)
	else:
		current_health = 100.0
		_health_bar_3D.setup(100)
	
	_damage_sensor.received.connect(_on_damage_received)

# ===
# Public
# ===

func die() -> void:
	if is_dead: return
	
	is_dead = true
	died.emit()
	queue_free()

# ===
# Private
# ===

# ===
# Signals
# ===

func _on_damage_received(data: DamageData) -> void:
	if is_dead: return
	
	current_health -= data.amount
	_health_bar_3D.update_health(current_health)
	
	if current_health <= 0:
		die()
