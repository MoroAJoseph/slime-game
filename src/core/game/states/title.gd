# Title
extends GameState

# ===
# Public
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	EventBus.subscribe(_on_event)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	WorldEvent.LevelLoadRequest.new(Constants.LEVEL_TITLE_SCENE_PATH, null, true)

func exit() -> void:
	_hud.hide_all()
	_menus.hide_all()
	EventBus.unsubscribe(_on_event)

# ===
# Private
# ===

func _handle_world_event(event: WorldEvent) -> void:
	if event is WorldEvent.LevelLoadNotify:
		_menus.toggle(Constants.MenuOption.MAIN, true)

func _handle_ui_event(event: UIEvent) -> void:
	if event is UIEvent.MainMenu:
		match event.action:
			UIEvent.MainMenuAction.PLAY:
				_transition_to(StateName.LOAD, LoadStateData.new(StateName.PLAY, Constants.LEVEL_HUB_SCENE_PATH))
			UIEvent.MainMenuAction.EXIT:
				get_tree().quit()

# ===
# Signals
# ===

func _on_event(event: Event) -> void:
	# World
	if event is WorldEvent:
		_handle_world_event(event)
	
	# UI
	elif event is UIEvent:
		_handle_ui_event(event)
