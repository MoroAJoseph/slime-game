class_name GameState
extends State

enum StateName { TITLE, HUB, EXPEDITION, LOAD }

var _owner: Game

# ===
# Built-In
# ===

func _ready() -> void:
	await owner.ready
	_owner = owner as Game
	assert(_owner != null, _get_assert_message("GameState", "Game"))

# ===
# Public
# ===

class LoadStateData extends RefCounted:
	var target_state: StateName
	var level_path: String
	func _init(_target_state: StateName, _level_path: String = ""):
		target_state = _target_state
		level_path = _level_path

func get_state_name(state: StateName) -> String:
	return StateName.keys()[state].capitalize()

# ===
# Private
# ===

func _transition_to(state: StateName, data: Object) -> void:
	finished.emit(get_state_name(state), data)
