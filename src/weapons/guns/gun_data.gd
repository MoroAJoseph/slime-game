@tool
class_name GunData
extends WeaponData

@export var parts: Dictionary[GunPartVisualData.GunPartSocket, GunPartVisualData] = {}:
	set(v):
		parts = v
		# Signal bubbling: if any part in the loadout changes, the gun rebuilds
		for part in parts.values():
			if part and not part.is_connected("changed", emit_changed):
				part.changed.connect(emit_changed)
		emit_changed()

## The function the Assembler was looking for
func get_part(socket: GunPartVisualData.GunPartSocket) -> GunPartVisualData:
	if parts.has(socket):
		return parts[socket]
	return null
