@tool
class_name WeaponResource
extends Resource

## Universal helper to handle signal bubbling for nested resources.
func _update_resource(old_res: Resource, new_res: Resource) -> Resource:
	if old_res and old_res.is_connected("changed", emit_changed):
		old_res.disconnect("changed", emit_changed)
	
	if new_res:
		if not new_res.is_connected("changed", emit_changed):
			new_res.changed.connect(emit_changed)
	
	emit_changed()
	return new_res
