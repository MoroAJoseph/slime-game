class_name BackpackData
extends Resource

@export var max_carry_weight: float

@export_group("Inventory")
@export var liquid_essence: float 
@export var gun_parts: Array[GunPartData]
@export var guns: Array[GunData]
# sword parts
# swords
@export var cores: Array

func get_current_carry_weight() -> float:
	var weight: float = 0.0
	
	# Gun Parts
	for gun_part in gun_parts:
		weight += gun_part.weight
	
	# Guns
	for gun in guns:
		weight += gun.weight
	
	return weight

func get_weapons() -> Array[WeaponData]:
	var value: Array[WeaponData] = []
	
	value.append_array(guns)

	return value

func get_weapon_parts() -> Array:
	var value: Array = []
	
	value.append_array(gun_parts)
	
	return value
