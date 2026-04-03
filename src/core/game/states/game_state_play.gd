extends GameState

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventBus.subscribe(_on_event)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			EventBus.publish(EventBus.GameplayEvent.RequestResume.new())
		else:
			EventBus.publish(EventBus.GameplayEvent.RequestPause.new())

func exit() -> void:
	get_tree().paused = false
	EventBus.unsubscribe(_on_event)

# ===
# Local
# ===

func _pause_game() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EventBus.publish(EventBus.GameplayEvent.GamePaused.new())

func _resume_game() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventBus.publish(EventBus.GameplayEvent.GameResumed.new())

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.GameplayEvent.RequestPause:
		_pause_game()
	elif event is EventBus.GameplayEvent.RequestResume:
		_resume_game()
	elif event is EventBus.PlayerEvent.Spawned:
		EventBus.publish(EventBus.UIEvent.ToggleHud.new(true))
	elif event is EventBus.UIEvent.PauseMenuAction:
		_on_ui_event_pause_menu_action(event)

# --- UI ---
func _on_ui_event_pause_menu_action(event: EventBus.UIEvent.PauseMenuAction) -> void:
	match event.action:
		event.Action.RESUME:
			_resume_game()
		event.Action.EXIT:
			_transition_to(StateName.LOAD, LoadStateData.new(StateName.TITLE))
		event.Action.QUIT:
			get_tree().quit()
