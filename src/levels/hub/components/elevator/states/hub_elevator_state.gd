class_name HubElevatorState
extends State

enum StateName { IDLE, TRANSIT, ARRIVED }

var _owner: HubElevator

# ===
# Built-In
# ===

func _ready() -> void:
	await owner.ready
	_owner = owner as HubElevator
	assert(_owner != null, _get_assert_message("HubElevatorState", "HubElevator"))

# ===
# Public
# ===

class TransitData:
	var target_floor_index: int
	var target_position: Vector3
	func _init(_target_floor_index: int, _target_position: Vector3):
		target_floor_index = _target_floor_index
		target_position = _target_position

func get_state_name(state: StateName) -> String:
	return StateName.keys()[state].capitalize()

# ===
# Private
# ===

func _transition_to(state: StateName, data: Object = null) -> void:
	finished.emit(get_state_name(state), data)
