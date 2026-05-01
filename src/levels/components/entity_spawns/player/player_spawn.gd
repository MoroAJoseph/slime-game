@tool
class_name PlayerSpawn
extends EntitySpawn

@export var player_data: PlayerData:
	set(value):
		player_data = value
		entity_data = value

# ===
# Private
# ===

func _get_spawn_color() -> Color:
	return Color.GREEN

func _get_spawn_label() -> String:
	return "PLAYER"
