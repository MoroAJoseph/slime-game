class_name GameState
extends State

enum StateName { LOAD, TITLE, PLAY }

var _owner: Game
var _world: Node3D
var _hud: CanvasLayer
var _menus: CanvasLayer
var _loading: CanvasLayer

# ===
# Built-In
# ===

func _ready() -> void:
	await owner.ready
	
	_owner = owner as Game
	_world = owner.get_world()
	_hud = owner.get_hud()
	_menus = owner.get_menus()
	_loading = owner.get_loading()

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
