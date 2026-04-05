class_name EndlessElevatorState
extends State

enum StateName { IDLE, TRANSIT, ARRIVED }

var _elevator: EndlessHubElevator
var _animation_player: AnimationPlayer

# ===
# Local
# ===

func setup(elevator: EndlessHubElevator) -> void:
	_elevator = elevator
	_animation_player = elevator.ANIMATION_PLAYER

func get_state_name(state: StateName) -> String:
	# This converts IDLE to "Idle", TRANSIT to "Transit", etc.
	return StateName.keys()[state].capitalize()

func _transition_to(state: StateName, data: Object = null) -> void:
	finished.emit(get_state_name(state), data)
