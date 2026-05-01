@tool
class_name SlimeData
extends EntityData

@export_group("Combat Stats")
@export var current_health: float = 100.0:
	set(value):
		current_health = value
		emit_changed()

@export var max_health: float = 100.0:
	set(value):
		max_health = value
		emit_changed()

@export var damage_amount: float = 10.0:
	set(value):
		damage_amount = value
		emit_changed()

@export var speed: float = 3.0:
	set(value):
		speed = value
		emit_changed()

@export_group("Visuals")
@export var slime_color: Color = Color.CYAN:
	set(value):
		slime_color = value
		emit_changed()
