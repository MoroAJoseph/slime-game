# Idle
extends HubElevatorState

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	if _prev_state_path == "":
		_owner._animation_player.play("open_door")
	
	_owner._player_detector.entered.connect(_on_player_entered)
	_owner._player_detector.exited.connect(_on_player_exited)
	_owner._menu_3D.floor_selected.connect(_on_floor_selected)

func exit() -> void:
	_owner._player_detector.entered.disconnect(_on_player_entered)
	_owner._player_detector.exited.disconnect(_on_player_exited)
	_owner._menu_3D.floor_selected.disconnect(_on_floor_selected)

# ===
# Signals
# ===

func _on_player_entered(_sensor: PlayerSensor) -> void:
	_owner._menu_3D.show()

func _on_player_exited(__sensor: PlayerSensor) -> void:
	_owner._menu_3D.hide()

func _on_floor_selected(index: int) -> void:
	var target_marker = _owner._floor_map.get(index as HubElevator.Floor)
	
	if target_marker:
		var target_pos = target_marker.global_position
		_transition_to(StateName.TRANSIT, TransitData.new(index, target_pos))
	else:
		push_error("Elevator: No marker found for floor index %d" % index)
