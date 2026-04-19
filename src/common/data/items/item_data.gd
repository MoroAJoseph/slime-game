class_name ItemData
extends Resource

enum Rarity { 
	COMMON = 0, 
	UNCOMMON = 1,
	RARE = 2, 
	EPIC = 3, 
	LEGENDARY = 4, 
	MYTHIC = 5 
}

enum Type { 
	WEAPON, 
	WEAPON_PART, 
	CORE 
}

@export var name: String
@export var type: Type
@export var rarity: Rarity
