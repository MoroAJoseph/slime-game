class_name PlayerDamageController
extends Node

@export var sensor: DamageSensor

@onready var player: Player = get_parent()

var _is_invulnerable: bool = false

# ===
# Built-In
# ===

func _ready() -> void:
	sensor.received.connect(_on_damage_received)

# ===
# Public
# ===

func set_invulnerable(value: bool) -> void:
	_is_invulnerable = value
	sensor.is_active = !value

# ===
# Private
# ===

func _trigger_iframes(duration: float) -> void:
	set_invulnerable(true)
	await get_tree().create_timer(duration).timeout
	set_invulnerable(false)

# ===
# Signals
# ===

func _on_damage_received(damage_data: DamageData) -> void:
	if _is_invulnerable: return
	
	player.data.current_health -= damage_data.amount
	
	if player.data.current_health <= 0:
		player.die()
	else:
		_trigger_iframes(0.5)
		# Optional: Add camera shake or knockback here
