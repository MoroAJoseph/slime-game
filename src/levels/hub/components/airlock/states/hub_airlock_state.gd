class_name HubAirlockState
extends State

enum StateName { IDLE, TRANSIT, ARRIVED }

var _owner: HubAirlock

# ===
# Built-In
# ===

func _ready() -> void:
	await owner.ready
	_owner = owner as HubAirlock
	assert(_owner != null, _get_assert_message("HubAirlockState", "HubAirlock"))

# ===
# Public
# ===

func get_state_name(state: StateName) -> String:
	return StateName.keys()[state].capitalize()

# ===
# Private
# ===

func _transition_to(state: StateName, data: Object = null) -> void:
	finished.emit(get_state_name(state), data)
