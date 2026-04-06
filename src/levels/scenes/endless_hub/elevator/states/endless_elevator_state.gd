class_name EndlessElevatorState
extends State

enum StateName { IDLE, TRANSIT, ARRIVED }

var _owner: EndlessHubElevator
var _menu: ElevatorMenu3D
var _animation_player: AnimationPlayer
var _player_detector: PlayerDetector
var _floor_map: Dictionary

# ===
# Public
# ===

class TransitData:
	var target_floor_index: int
	var target_position: Vector3
	func _init(_target_floor_index: int, _target_position: Vector3):
		target_floor_index = _target_floor_index
		target_position = _target_position

func setup(owner: EndlessHubElevator) -> void:
	_owner = owner
	_menu = owner.MENU
	_animation_player = owner.ANIMATION_PLAYER
	_player_detector = owner.PLAYER_DETECTOR
	_floor_map = owner.FLOOR_MAP

func get_state_name(state: StateName) -> String:
	# This converts IDLE to "Idle", TRANSIT to "Transit", etc.
	return StateName.keys()[state].capitalize()

# ===
# Private
# ===

func _transition_to(state: StateName, data: Object = null) -> void:
	finished.emit(get_state_name(state), data)
