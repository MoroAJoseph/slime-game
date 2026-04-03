@tool
class_name WeaponPartVisualData
extends Resource

@export var item_name: String: 
	set(v): 
		item_name = v
		emit_changed()
@export_file("*.res") var mesh_file_path: String: 
	set(v): 
		mesh_file_path = v
		emit_changed()
@export var default_red: Color = Color.DARK_GRAY: 
	set(v): 
		default_red = v
		emit_changed()
@export var default_green: Color = Color.DIM_GRAY: 
	set(v): 
		default_green = v
		emit_changed()
@export var default_blue: Color = Color.BLACK: 
	set(v): 
		default_blue = v
		emit_changed()
