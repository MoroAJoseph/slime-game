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
		elif get_tree().paused:
			_resume_game()
		else:
			_pause_game()
	
	elif event.is_action_pressed("menu_inventory"):
		var type = _ui_controller.MenuType.INVENTORY
		var is_open = _ui_controller.is_menu_open(type)
		_ui_controller.toggle_menu(type, !is_open)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if !is_open else Input.MOUSE_MODE_CAPTURED

func exit() -> void:
	get_tree().paused = false
	_ui_controller.hide_all()
	EventBus.unsubscribe(_on_event)

# ===
# Private
# ===

func _pause_game() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_ui_controller.toggle_menu(UIController.MenuType.PAUSE, true)
	GameEvent.PausedUpdated.new(true)

func _resume_game() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_ui_controller.close_all_menus()
	GameEvent.PausedUpdated.new(false)

func _handle_interaction_request(request: WorldEvent.InteractionRequest) -> void:
	var target = request.data.target
	
	if _ui_controller.has_open_menus():
		WorldEvent.InteractionResponse.new(request, Event.ResponseResult.FAIL, "Menu already open")
		return

	if target is BuilderBench:
		_ui_controller.toggle_menu(UIController.MenuType.BUILDER_BENCH, true)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		WorldEvent.InteractionResponse.new(request, Event.ResponseResult.SUCCESS, "")

	elif target is Dismantler:
		_ui_controller.toggle_menu(UIController.MenuType.DISMANTLER, true)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		WorldEvent.InteractionResponse.new(request, Event.ResponseResult.SUCCESS, "")
	
	elif target is ToWorld:
		_transition_to(StateName.LOAD, LoadStateData.new(StateName.EXPEDITION, Constants.LEVEL_WORLD_SCENE_PATH))
		
	# All other interaction
	else:
		WorldEvent.InteractionResponse.new(request, Event.ResponseResult.SUCCESS, "")

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	# UI
	if event is UIEvent:
		_on_ui_event(event)
	
	# World
	elif event is WorldEvent:
		_on_world_event(event)

func _on_world_event(event: WorldEvent) -> void:
	if event is WorldEvent.EntitySpawned:
		
		# Player
		if event.node is Player:
			match Session.current_mode:
				Session.GameMode.STORY:
					_ui_controller.toggle_hud(UIController.HUDType.HUB, true)
	
	# Interaction Request
	elif event is WorldEvent.InteractionRequest:
		_handle_interaction_request(event)

func _on_ui_event(event: UIEvent) -> void:
	# Inventory
	if event is UIEvent.InventoryMenu:
		match event.action:
			
			# Close
			UIEvent.InventoryMenuAction.CLOSE:
				_ui_controller.toggle_menu(UIController.MenuType.INVENTORY, false)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Dismantler
	elif event is UIEvent.DismantlerMenu:
		match event.action:
			
			# Close
			UIEvent.DismantlerMenuAction.CLOSE:
				_ui_controller.toggle_menu(UIController.MenuType.DISMANTLER, false)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
			# Dismantle
			UIEvent.DismantlerMenuAction.DISMANTLE:
				pass
	
	# Provisioner
	elif event is UIEvent.ProvisionerMenu:
		match event.action:
			
			# Close
			UIEvent.ProvisionerMenuAction.CLOSE:
				_ui_controller.toggle_menu(UIController.MenuType.PROVISIONER, false)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Builder Bench
	elif event is UIEvent.BuilderBenchMenu:
		match event.action:
			
			# Close
			UIEvent.BuilderBenchMenuAction.CLOSE:
				_ui_controller.toggle_menu(UIController.MenuType.BUILDER_BENCH, false)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Pause
	elif event is UIEvent.PauseMenu:
		match event.action:
			
			# Resume
			UIEvent.PauseMenuAction.RESUME:
				_resume_game()
			
			# Exit
			UIEvent.PauseMenuAction.EXIT:
				_transition_to(StateName.LOAD, LoadStateData.new(StateName.TITLE))
			
			# Quit
			UIEvent.PauseMenuAction.QUIT:
				get_tree().quit()
