@tool
class_name GunPartVisualData
extends WeaponPartVisualData

enum GunType { RIFLE, SMG, PISTOL, SNIPER, SHOTGUN }
enum GunPartSocket { FRAME, STOCK, MAG, BARREL, MUZZLE, UNDER_BARREL, REAR_SIGHT, FRONT_SIGHT, BULLET_SPAWN }

@export var type: GunType: 
	set(v): 
		type = v
		emit_changed()
@export var socket: GunPartSocket: 
	set(v): 
		socket = v
		emit_changed()
@export var sockets: Dictionary[GunPartSocket, WeaponPartSocketData] = {}:
	set(v):
		sockets = v
		for s_data in sockets.values():
			if s_data and not s_data.is_connected("changed", emit_changed):
				s_data.changed.connect(emit_changed)
		emit_changed()
@export var update_sockets: bool:
	set(v):
		for s_data in sockets.values():
			if s_data and not s_data.is_connected("changed", emit_changed):
				s_data.changed.connect(emit_changed)
		emit_changed()
