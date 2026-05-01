class_name DroneState
extends State

enum StateName { IDLE }

var _owner: Drone

# ===
# Built-In
# ===

func _ready() -> void:
	await owner.ready
	
	_owner = owner as Drone
	assert(_owner != null, _get_assert_message("DroneState", "Drone"))

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
