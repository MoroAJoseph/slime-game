@tool
class_name GunPartCombatData 
extends GunResource

@export var weight: float = 0.5:
	set(v): 
		weight = v
		emit_changed()
