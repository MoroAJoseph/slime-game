# Play
extends GameState

# ===
# Public
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventBus.subscribe(_on_event)

func exit() -> void:
	_hud.hide_all()
	EventBus.unsubscribe(_on_event)

# ===
# Private
# ===

func _handle_world_event(event: WorldEvent) -> void:
	# Entity Spawn
	if event is WorldEvent.EntitySpawnNotify:
		
		# Player
		if event.node is Player:
			var is_safe: bool = true
			var hud_option: Constants.HUDOption = Constants.HUDOption.SAFE if is_safe else Constants.HUDOption.EXPEDITION
			_hud.toggle(hud_option, true)
	
	# Entity Death
	elif event is WorldEvent.EntityDieNotify:
		
		# Player
		if event.node is Player:
			# hide hud
			# show death screen
			pass
	
	# Interaction Request
	#elif event is WorldEvent.InteractionRequest:
		#_handle_interaction_request(event)

#func _handle_ui_event(event: UIEvent) -> void:
	## Inventory
	#if event is UIEvent.InventoryMenu:
		#match event.action:
			#
			## Close
			#UIEvent.InventoryMenuAction.CLOSE:
				#_ui_controller.toggle_menu(UIController.MenuType.INVENTORY, false)
				#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#
	## Dismantler
	#elif event is UIEvent.DismantlerMenu:
		#match event.action:
			#
			## Close
			#UIEvent.DismantlerMenuAction.CLOSE:
				#_ui_controller.toggle_menu(UIController.MenuType.DISMANTLER, false)
				#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#
			## Dismantle
			#UIEvent.DismantlerMenuAction.DISMANTLE:
				#pass
	#
	## Provisioner
	#elif event is UIEvent.ProvisionerMenu:
		#match event.action:
			#
			## Close
			#UIEvent.ProvisionerMenuAction.CLOSE:
				#_ui_controller.toggle_menu(UIController.MenuType.PROVISIONER, false)
				#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#
	## Pause
	#elif event is UIEvent.PauseMenu:
		#match event.action:
			#
			## Resume
			#UIEvent.PauseMenuAction.RESUME:
				#_resume_game()
			#
			## Exit
			#UIEvent.PauseMenuAction.EXIT:
				#_transition_to(StateName.LOAD, LoadStateData.new(StateName.TITLE))
			#
			## Quit
			#UIEvent.PauseMenuAction.QUIT:
				#get_tree().quit()

# ===
# Signals
# ===

func _on_event(event: Event) -> void:
	# World
	if event is WorldEvent:
		_handle_world_event(event)
	
	# UI
	#if event is UIEvent:
		#_handle_ui_event(event)
	
