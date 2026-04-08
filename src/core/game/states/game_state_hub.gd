# Hub
extends GameState

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventBus.subscribe(_on_event)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if _ui_controller.has_open_menus():
			_ui_controller.close_all_menus()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			match Session.current_mode:
				Session.GameMode.ENDLESS:
					_ui_controller.toggle_menu(UIController.MenuType.ENDLESS_HUB_MAIN, true)
				Session.GameMode.SANDBOX:
					pass
	
	elif event.is_action_pressed("menu_inventory"):
		var type = _ui_controller.MenuType.ENDLESS_INVENTORY
		var is_open = _ui_controller.is_menu_open(type)
		_ui_controller.toggle_menu(type, !is_open)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if !is_open else Input.MOUSE_MODE_CAPTURED

func exit() -> void:
	get_tree().paused = false
	_ui_controller.hide_all()
	EventBus.unsubscribe(_on_event)

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	# Entity Spawned
	if event is WorldEvent.EntitySpawned:
		
		# Player
		if event.node is Player:
			match Session.current_mode:
				Session.GameMode.ENDLESS:
					_ui_controller.toggle_endless_hub_hud(true)
				Session.GameMode.SANDBOX:
					pass
	
	# Endless Hub Main
	elif event is UIEvent.EndlessHubMain:
		match event.action:
			
			# Close
			UIEvent.EndlessHubMainAction.CLOSE:
				_ui_controller.toggle_menu(UIController.MenuType.ENDLESS_HUB_MAIN, false)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
			# Exit
			UIEvent.EndlessHubMainAction.EXIT:
				_transition_to(StateName.LOAD, LoadStateData.new(StateName.TITLE))
			
			# Quit
			UIEvent.EndlessHubMainAction.QUIT:
				get_tree().quit()
	
	# Endless Hub Inventory
	elif event is UIEvent.EndlessHubInventory:
		match event.action:
			
			# Close
			UIEvent.EndlessHubInventoryAction.CLOSE:
				_ui_controller.toggle_menu(UIController.MenuType.ENDLESS_INVENTORY, false)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Endless Hub Dismantler
	elif event is UIEvent.EndlessHubDismantler:
		match event.action:
			
			# Close
			UIEvent.EndlessHubDismantlerAction.CLOSE:
				_ui_controller.toggle_menu(UIController.MenuType.ENDLESS_HUB_DISMANTLER, false)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
			# Dismantle
			UIEvent.EndlessHubDismantlerAction.DISMANTLE:
				pass
	
	# Endless Hub Provisioner
	elif event is UIEvent.EndlessHubProvisioner:
		pass
	
	# Interaction Request
	elif event is WorldEvent.InteractionRequest:
		_handle_interaction_request(event)

func _handle_interaction_request(request: WorldEvent.InteractionRequest) -> void:
	var target = request.data.target
	
	if _ui_controller.has_open_menus():
		WorldEvent.InteractionResponse.new(request, Event.ResponseResult.FAIL, "Menu already open")
		return

	if target is BuilderBench:
		_ui_controller.toggle_menu(UIController.MenuType.ENDLESS_HUB_BUILDER_BENCH, true)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		WorldEvent.InteractionResponse.new(request, Event.ResponseResult.SUCCESS, "")

	elif target is Dismantler:
		_ui_controller.toggle_menu(UIController.MenuType.ENDLESS_HUB_DISMANTLER, true)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		WorldEvent.InteractionResponse.new(request, Event.ResponseResult.SUCCESS, "")
		
	else:
		# Fallback for generic objects (doors, chests, etc.)
		WorldEvent.InteractionResponse.new(request, Event.ResponseResult.SUCCESS, "")
