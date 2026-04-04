# Arrived
extends EndlessElevatorState

func enter(_prev_state_path: String, data: Object) -> void:
	var transit_data = data as ElevatorTransitData
	if not transit_data:
		_transition_to(StateName.IDLE)
		return

	# 1. Calculate the movement delta using the confirmed _elevator ref
	var old_pos = _elevator.global_position
	var new_pos = transit_data.target_position
	var offset = new_pos - old_pos
	
	# 2. Teleport the entire Elevator Root
	_elevator.global_position = new_pos
	
	# 3. Teleport the Player relative to the new position
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.global_position += offset
	
	if _elevator.MENU.ui_menu:
		_elevator.MENU.ui_menu.set_current_floor(transit_data.target_floor_index)
	
	# 4. Open doors and finish
	if _animation_player:
		_animation_player.play("open_door")
		# Wait for doors to actually open before letting player move
		await _animation_player.animation_finished
	
	# Re-enable player movement
	EventBus.publish(EventBus.PlayerEvent.InputToggled.new(true))
	
	_transition_to(StateName.IDLE)
