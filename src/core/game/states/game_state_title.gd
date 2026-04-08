# Title
extends GameState

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Session.current_mode = Session.GameMode.NONE
	EventBus.subscribe(_on_event)
	_world_controller.load_scene(Constants.LEVEL_TITLE_SCENE_PATH)
	_ui_controller.toggle_menu(UIController.MenuType.TITLE_MAIN, true)

func exit() -> void:
	_ui_controller.hide_all()
	EventBus.unsubscribe(_on_event)

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	# Title
	if event is UIEvent.TitleMain:
		match event.action:
			UIEvent.TitleMainAction.SANDBOX:
				Session.current_mode = Session.GameMode.SANDBOX
				_transition_to(StateName.LOAD, LoadStateData.new(StateName.HUB, Constants.LEVEL_SANDBOX_SCENE_PATH))
			UIEvent.TitleMainAction.ENDLESS:
				Session.current_mode = Session.GameMode.ENDLESS
				_transition_to(StateName.LOAD, LoadStateData.new(StateName.HUB, Constants.LEVEL_ENDLESS_HUB_SCENE_PATH))
			UIEvent.TitleMainAction.EXIT:
				get_tree().quit()
