# Transit
extends HubElevatorState

var _data: TransitData

# ===
# Parent
# ===

func enter(_prev_state_path: String, data: Object) -> void:
	_data = data as TransitData
	_owner._animation_player.play("close_door")
	PlayerEvent.InputToggled.new(false)
	get_tree().create_timer(3.0).timeout.connect(_on_timeout)

func exit() -> void:
	_data = null

# ===
# Signals
# ===

func _on_timeout() -> void:
	_transition_to(StateName.ARRIVED, _data)
