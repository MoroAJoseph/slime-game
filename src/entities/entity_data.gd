@tool
class_name EntityData
extends Resource

@export var name: String:
	set(value):
		name = value
		emit_changed()
