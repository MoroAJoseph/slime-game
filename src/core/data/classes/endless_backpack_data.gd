class_name EndlessBackpackData
extends Resource

@export var gun_parts: Array[GunPartData]
@export var cores: Array[Resource]
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
