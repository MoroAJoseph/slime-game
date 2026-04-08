# Expedition
extends GameState

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventBus.subscribe(_on_event)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if _ui_controller.has_open_menus() or get_tree().paused:
			_resume_game()
		else:
			_pause_game()
	
	elif event.is_action_pressed("menu_inventory"):
		var type = _ui_controller.MenuType.ENDLESS_INVENTORY
		var is_open = _ui_controller.is_menu_open(type)
		_ui_controller.toggle_menu(type, !is_open)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if !is_open else Input.MOUSE_MODE_CAPTURED


func exit() -> void:
	get_tree().paused = false
	EventBus.unsubscribe(_on_event)

# ===
# Private
# ===

func _pause_game() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_ui_controller.toggle_menu(_ui_controller.MenuType.ENDLESS_EXPEDIION_PAUSE, true)
	GameEvent.PausedUpdated.new(true)

func _resume_game() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_ui_controller.close_all_menus()
	GameEvent.PausedUpdated.new(false)

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
					_ui_controller.toggle_endless_expedition_hud(true)
				Session.GameMode.SANDBOX:
					pass
	
	# Entity Died
	elif event is WorldEvent.EntityDied:
		
		# Player
		if event.node is Player:
			pass
	
	# Endless Expedition Pause
	elif event is UIEvent.EndlessExpeditionPause:
		match event.action:
			
			# Resume
			UIEvent.EndlessExpeditionPauseAction.RESUME:
				_resume_game()
			
			# Exit
			UIEvent.EndlessExpeditionPauseAction.EXIT:
				_transition_to(StateName.LOAD, LoadStateData.new(StateName.TITLE))
			
			# Quit
			UIEvent.EndlessExpeditionPauseAction.QUIT:
				get_tree().quit()
