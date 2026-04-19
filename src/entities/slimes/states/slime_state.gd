class_name SlimeState
extends State

enum StateName { IDLE, PATROL, COMBAT, DEAD }

var _owner: Slime
var _owner_data: SlimeData

# ===
# Built-In
# ===

func _ready() -> void:
	await owner.ready
	_owner = owner as Slime
	assert(_owner != null, _get_assert_message("SlimeState", "Slime"))
	
	_owner_data = owner.data

# ===
# Local
# ===

func get_state_name(state: StateName) -> String:
	return StateName.keys()[state].capitalize()

func _transition_to(state: StateName, data: Object) -> void:
	finished.emit(get_state_name(state), data)
