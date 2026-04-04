@tool
class_name GunMagCombatData 
extends GunPartCombatData

@export var ammo_capacity: int = 30:
	set(v):
		ammo_capacity = v
		emit_changed()
@export var reload_duration: float = 2.0: # Seconds
	set(v):
		reload_duration = v
		emit_changed()
