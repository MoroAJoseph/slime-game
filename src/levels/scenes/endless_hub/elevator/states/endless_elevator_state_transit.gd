# Transit
extends EndlessElevatorState

var _pending_data: ElevatorTransitData

func enter(_prev_state_path: String, data: Object) -> void:
	_pending_data = data as ElevatorTransitData
	
	# Lock the player and close the physical doors
	_animation_player.play("close_door")
	EventBus.publish(EventBus.PlayerEvent.InputToggled.new(false)) 
	
	# Duration of the "travel"
	get_tree().create_timer(3.0).timeout.connect(_on_timeout)

func _on_timeout() -> void:
	_transition_to(StateName.ARRIVED, _pending_data)

func exit() -> void:
	_pending_data = null
