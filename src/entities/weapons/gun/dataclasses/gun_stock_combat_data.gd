@tool
class_name GunStockCombatData
extends GunPartCombatData

@export var recoil_recovery: float = 5.0:
	set(v): 
		recoil_recovery = v
		emit_changed()
@export var idle_sway_amount: float = 1.0:
	set(v): 
		idle_sway_amount = v
		emit_changed()
@export var flinch_resistance: float = 0.2:
	set(v): 
		flinch_resistance = v
		emit_changed()
