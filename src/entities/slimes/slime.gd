class_name Slime
extends CharacterBody3D

signal died

@onready var MODEL_CONTROLLER: SlimeModelController = $ModelController
@onready var HEALTH_BAR: HealthBar3D = $HealthBar3D
@onready var DAMAGE_SENSOR: DamageSensor = $DamageSensor

var data: SlimeData
var current_health: float
var is_dead: bool = false

# ===
# Built-In
# ===

func _ready() -> void:
	if data:
		_initialize_from_data()
	else:
		current_health = 100.0
		HEALTH_BAR.setup(100)
	DAMAGE_SENSOR.received.connect(_on_damage_received)

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

func _initialize_from_data() -> void:
	current_health = data.max_health
	HEALTH_BAR.setup(data.max_health)
	MODEL_CONTROLLER.apply_slime_color(data.slime_color)

# ===
# Signals
# ===

func _on_damage_received(damage_data: DamageData) -> void:
	if is_dead: return
	current_health -= damage_data.amount
	
	# Update HealthBar
	var progress_bar = $HealthBar3D/SubViewport/ProgressBar
	if progress_bar:
		progress_bar.value = current_health
	
	if current_health <= 0:
		die()
