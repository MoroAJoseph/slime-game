@tool
class_name PlayerSpawnPoint
extends EntitySpawnPoint

@export var player_data: PlayerData:
	set(value):
		player_data = value
		entity_data = value

func _get_spawn_color() -> Color:
	return Color.GREEN

func _get_spawn_label() -> String:
	var p_name = player_data.name if player_data else "DEFAULT"
	return "PLAYER: " + p_name
