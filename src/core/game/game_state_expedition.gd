# Expedition
extends GameState

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventBus.subscribe(_on_event)

func handle_input(event: InputEvent) -> void:
	# 
	if event.is_action_pressed("menu"):
		if _ui_controller.has_open_menus() or get_tree().paused:
			_resume_game()
		else:
			_pause_game()
	
	# Inventory
	elif event.is_action_pressed("menu_inventory"):
		var type = _ui_controller.MenuType.ENDLESS_INVENTORY_MENU
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
	_ui_controller.toggle_menu(_ui_controller.MenuType.PAUSE, true)
	EventBus.publish(EventBus.GameplayEvent.GamePaused.new())

func _resume_game() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_ui_controller.close_all_menus()
	EventBus.publish(EventBus.GameplayEvent.GameResumed.new())

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.PlayerEvent.Spawned:
		_ui_controller.toggle_hud(true)
	elif event is EventBus.PlayerEvent.Died:
		# Show a death menu
		pass
	#elif event is EventBus.UIEvent.DeathMenuAction:
		#pass
	elif event is EventBus.UIEvent.PauseMenuAction:
		match event.action:
			event.Action.RESUME:
				_resume_game()
			event.Action.EXIT:
				_transition_to(StateName.LOAD, LoadStateData.new(StateName.TITLE))
			event.Action.QUIT:
				get_tree().quit()
