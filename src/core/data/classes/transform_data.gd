@tool
class_name TransformData
extends Resource

@export var position: Vector3 = Vector3.ZERO:
	set(v):
		position = v
		emit_changed()
@export var rotation: Vector3 = Vector3.ZERO:
	set(v):
		rotation = v
		emit_changed()
@export var scale: Vector3 = Vector3.ONE:
	set(v):
		scale = v
		emit_changed()
