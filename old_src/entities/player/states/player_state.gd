class_name PlayerState
extends State

enum StateName { IDLE, WALK, RUN, JUMP, FALL }

var _owner: Player
var _owner_data: PlayerData 

# ===
# Built-In
# ===

func _ready() -> void:
	await owner.ready
	_owner = owner as Player
	_owner_data = owner.data as PlayerData
	assert(_owner != null, _get_assert_message("PlayerState", "Player"))

# ===
# Local
# ===

func get_state_name(state: StateName) -> String:
	return StateName.keys()[state].capitalize()

func _transition_to(state: StateName, data: Object) -> void:
	finished.emit(get_state_name(state), data)
