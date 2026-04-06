# Title
extends GameState

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Session.current_mode = Session.GameMode.NONE
	EventBus.subscribe(_on_event)
	_world_controller.load_scene(_title_level_path)
	_ui_controller.toggle_main_menu(true)

func exit() -> void:
	_ui_controller.hide_all()
	EventBus.unsubscribe(_on_event)

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.UIEvent.MainMenuAction:
		match event.action:
			event.Action.SANDBOX:
				Session.current_mode = Session.GameMode.SANDBOX
				_transition_to(StateName.LOAD, LoadStateData.new(StateName.HUB, _sandbox_path))
			event.Action.ENDLESS:
				Session.current_mode = Session.GameMode.ENDLESS
				_transition_to(StateName.LOAD, LoadStateData.new(StateName.HUB, _endless_hub_path))
			event.Action.EXIT:
				get_tree().quit()
