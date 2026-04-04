@tool
class_name GunPartVisualData
extends GunResource

@export_file("*.res", "*.mesh") var mesh_path: String:
	set(v): 
		mesh_path = v
		emit_changed()
@export var color_red: Color = Color.DARK_GRAY:
	set(v): 
		color_red = v
		emit_changed()
@export var color_green: Color = Color.DIM_GRAY:
	set(v): 
		color_green = v
		emit_changed()
@export var color_blue: Color = Color.BLACK:
	set(v): 
		color_blue = v
		emit_changed()
@export var socket_transforms: Dictionary[GunPartSocket, TransformData] = {}:
	set(v):
		socket_transforms = v
		for data in socket_transforms.values():
			_connect_res(null, data)
		emit_changed()
