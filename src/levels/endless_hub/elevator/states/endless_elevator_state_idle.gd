# Idle
extends EndlessElevatorState

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	if _prev_state_path == "":
		_animation_player.play("open_door")
	
	_player_detector.entered.connect(_on_player_entered)
	_player_detector.exited.connect(_on_player_exited)
	_menu.floor_selected.connect(_on_floor_selected)

func exit() -> void:
	_player_detector.entered.disconnect(_on_player_entered)
	_player_detector.exited.disconnect(_on_player_exited)
	_menu.floor_selected.disconnect(_on_floor_selected)

# ===
# Signals
# ===

func _on_player_entered(_sensor: PlayerSensor) -> void:
	_menu.show()

func _on_player_exited(__sensor: PlayerSensor) -> void:
	_menu.hide()

func _on_floor_selected(index: int) -> void:
	var target_marker = _floor_map.get(index as EndlessHubElevator.Floor)
	
	if target_marker:
		var target_pos = target_marker.global_position
		_transition_to(StateName.TRANSIT, TransitData.new(index, target_pos))
	else:
		push_error("Elevator: No marker found for floor index %d" % index)
