# Arrived
extends HubElevatorState

# ===
# Parent
# ===

func enter(_prev_state_path: String, data: Object) -> void:
	var transit_data = data as TransitData
	if not transit_data:
		_transition_to(StateName.IDLE)
		return

	var old_pos = _owner.global_position
	var new_pos = transit_data.target_position
	var offset = new_pos - old_pos
	
	_owner.global_position = new_pos
	
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.global_position += offset
	
	if _owner._menu_3D.ui_menu:
		_owner._menu_3D.ui_menu.set_current_floor(transit_data.target_floor_index)
	
	if _owner._animation_player:
		_owner._animation_player.play("open_door")
		await _owner._animation_player.animation_finished
	
	PlayerEvent.InputToggled.new(true)
	
	_transition_to(StateName.IDLE)
