@tool
class_name GunFrameCombatData 
extends GunPartCombatData

@export var base_damage: float = 10.0:
	set(v):
		base_damage = v
		emit_changed()
@export var fire_rate: float = 600:
	set(v):
		fire_rate = v
		emit_changed()
@export var fire_modes: Array[GunFireMode] = [GunFireMode.SEMI_AUTO]:
	set(v):
		fire_modes = v
		emit_changed()
