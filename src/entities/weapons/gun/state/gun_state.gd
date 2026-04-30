class_name GunState
extends State

enum StateName { READY, RELOAD, FIRE }

var _owner: Gun

# ===
# Built-In
# ===

func _ready() -> void:
	await owner.ready
	
	_owner = owner as Gun
	assert(_owner != null, _get_assert_message("GunState", "Gun"))

# ===
# Public
# ===

func get_state_name(state: StateName) -> String:
	return StateName.keys()[state].capitalize()

# ===
# Private
# ===

func _transition_to(state: StateName, data: Object) -> void:
	finished.emit(get_state_name(state), data)
