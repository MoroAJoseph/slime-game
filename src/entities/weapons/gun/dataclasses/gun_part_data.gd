@tool
class_name GunPartData
extends GunResource

@export var item_name: String: 
	set(v): 
		item_name = v
		emit_changed()
@export var type: GunType: 
	set(v): 
		type = v
		emit_changed()
@export var socket: GunPartSocket: 
	set(v): 
		socket = v
		emit_changed()
@export var visual_data: GunPartVisualData:
	set(v): 
		visual_data = _connect_res(visual_data, v)
		notify_property_list_changed()
@export var combat_data: GunPartCombatData:
	set(v): 
		combat_data = _connect_res(combat_data, v)
		notify_property_list_changed()
