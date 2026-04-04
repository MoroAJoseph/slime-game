@tool
class_name GunMuzzleCombatData
extends GunPartCombatData

@export_range(0.0, 1.0) var flash_intensity: float = 1.0:
	set(v):
		flash_intensity = v
		emit_changed()
@export var acoustic_range: int = 50: # Meters
	set(v):
		acoustic_range = v
		emit_changed()
@export var horizontal_recoil_multiplier: float = 1.0:
	set(v):
		horizontal_recoil_multiplier = v
		emit_changed()
