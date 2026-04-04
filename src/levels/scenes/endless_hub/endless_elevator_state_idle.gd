# Idle
extends EndlessElevatorState

func enter(_prev_state_path: String, _data: Object) -> void:
	if _prev_state_path == "":
		_animation_player.play("open_door")
