#@tool
#class_name SlimeSpawn
#extends EntitySpawn
#
#@export var slime_data: SlimeData:
	#set(value):
		#slime_data = value
		#entity_data = value
#
#func _get_spawn_color() -> Color:
	#if slime_data:
		#return slime_data.slime_color
	#return Color.RED
#
#func _get_spawn_label() -> String:
	#var slime_name = slime_data.name if slime_data else "NONE"
	#return "SLIME: " + slime_name
