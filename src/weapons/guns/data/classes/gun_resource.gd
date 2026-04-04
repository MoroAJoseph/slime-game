@tool
class_name GunResource
extends Resource

enum GunFireMode { SEMI_AUTO, BURST, FULL_AUTO, CHARGE, BEAM }
enum GunType { RIFLE, SMG, PISTOL, SNIPER, SHOTGUN }
enum GunPartSocket { FRAME, STOCK, MAG, BARREL, MUZZLE, UNDER_BARREL, REAR_SIGHT, FRONT_SIGHT, BULLET_SPAWN }

func _connect_res(old_res: Resource, new_res: Resource) -> Resource:
	if old_res and old_res.is_connected("changed", emit_changed):
		old_res.disconnect("changed", emit_changed)
	if new_res:
		if not new_res.is_connected("changed", emit_changed):
			new_res.changed.connect(emit_changed)
	emit_changed()
	return new_res
