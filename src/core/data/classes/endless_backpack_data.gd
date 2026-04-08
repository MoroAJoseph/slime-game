class_name EndlessBackpackData
extends Resource

@export var gun_parts: Array[GunPartData]
@export var staged_gun_parts: Array[GunPartData]

@export var cores: Array[Resource]
@export var staged_cores: Array[Resource]

@export var max_weapons_weight: float = 5.0
@export var max_cores_count: int = 1

func get_weapons() -> Array[WeaponData]:
	var weapons: Array[WeaponData] = []
	for part in gun_parts:
		weapons.append(part)
	
	return weapons

func get_total_weapons_weight() -> float:
	var weight: float = 0.0
	
	# Guns
	for part in gun_parts:
		weight += part.combat_data.weight
	
	# other weapons
	
	return weight

func stage_gun_aprt(part: GunPartData) -> void:
	if gun_parts.has(part):
		gun_parts.erase(part)
		staged_gun_parts.append(part)
		emit_changed()

func unstage_gun_part(part: GunPartData) -> void:
	if staged_gun_parts.has(part):
		staged_gun_parts.erase(part)
		gun_parts.append(part)
		emit_changed()

func commit_dismantle() -> int:
	var total_yield: int = 0
	for part in staged_gun_parts:
		total_yield += part.scrap_value
	
	staged_gun_parts.clear()
	emit_changed()
	return total_yield
