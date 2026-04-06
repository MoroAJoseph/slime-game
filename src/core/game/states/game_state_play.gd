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
					_ui_controller.toggle_endless_hub_menu(true)
				Session.GameMode.SANDBOX:
					pass
	
	elif event.is_action_pressed("menu_inventory"):
		var type = _ui_controller.MenuType.ENDLESS_INVENTORY_MENU
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

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.PlayerEvent.Spawned:
		match Session.current_mode:
			Session.GameMode.ENDLESS:
				_ui_controller.toggle_endless_hub_hud(true)
			Session.GameMode.SANDBOX:
				pass
	elif event is EventBus.UIEvent.EndlessHubMenuAction:
		match event.action:
			event.Action.CLOSE:
				_ui_controller.toggle_endless_hub_menu(false)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			event.Action.EXIT:
				_transition_to(StateName.LOAD, LoadStateData.new(StateName.TITLE))
			event.Action.QUIT:
				get_tree().quit()
	elif event is EventBus.UIEvent.EndlessInventoryMenuAction:
		match event.action:
			event.Action.CLOSE:
				_ui_controller.toggle_endless_inventory_menu(false)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
