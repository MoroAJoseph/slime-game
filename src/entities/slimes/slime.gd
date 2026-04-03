class_name Slime
extends CharacterBody3D

signal died

@onready var _model_controller: SlimeModelController = $ModelController
@onready var health_bar: HealthBar3D = $HealthBar3D

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
		health_bar.setup(100)

# ===
# Local
# ===

func _initialize_from_data() -> void:
	current_health = data.max_health
	health_bar.setup(data.max_health)
	_model_controller.apply_slime_color(data.slime_color)

func die() -> void:
	if is_dead: return
	is_dead = true
	$Hurtbox/CollisionShape3D.set_deferred("disabled", true)
	died.emit()
	queue_free()

# ===
# Signals
# ===

func _on_hurtbox_hit_received(damage_data: DamageData) -> void:
	if is_dead: return
	current_health -= damage_data.amount
	
	# Update HealthBar
	var progress_bar = $HealthBar3D/SubViewport/ProgressBar
	if progress_bar:
		progress_bar.value = current_health
	
	if current_health <= 0:
		die()
