@tool
class_name GunBarrelCombatData 
extends GunPartCombatData

@export var bullet_velocity: int = 1200: # Meters/Second
	set(v):
		bullet_velocity = v
		emit_changed()
@export_range(0.0, 1.0) var bullet_spread: float = 0.02:
	set(v):
		bullet_spread = v
		emit_changed()
@export var effective_range: int = 100: # Meters
	set(v):
		effective_range = v
		emit_changed()
