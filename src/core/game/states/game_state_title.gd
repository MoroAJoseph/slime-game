# Title
extends GameState

@export_file("*.tscn") var sandbox_path: String
@export_file("*.tscn") var endless_hub_path: String

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EventBus.subscribe(_on_event)
	EventBus.publish(EventBus.GameplayEvent.RequestLoadTitle.new())

func exit() -> void:
	EventBus.unsubscribe(_on_event)

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.UIEvent.MainMenuAction:
		_on_ui_event_main_menu_action(event)

# --- UI ---
func _on_ui_event_main_menu_action(event: EventBus.UIEvent.MainMenuAction) -> void:
	match event.action:
		event.Action.SANDBOX:
			# TODO Play animation
			if sandbox_path == "":
				push_error("Sandboxpath not set in Title State inspector!")
				return 
			_transition_to(StateName.LOAD, LoadStateData.new(StateName.PLAY, sandbox_path))

		event.Action.ENDLESS:
			# TODO Play animation
			if endless_hub_path == "":
				push_error("Endless Hub path not set in Title State inspector!")
				return
			_transition_to(StateName.LOAD, LoadStateData.new(StateName.PLAY, endless_hub_path))
		
		event.Action.SETTINGS:
			# TODO Play animation
			# Transition from main menu to settings menu
			pass
		
		event.Action.EXIT:
			# TODO Play animation
			get_tree().quit()
