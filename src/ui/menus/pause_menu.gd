extends Control

# ===
# Signals
# ===

# --- Button ---
func _on_resume_pressed() -> void:
	_publish_pause_action(EventBus.UIEvent.PauseMenuAction.Action.RESUME)

func _on_settings_pressed() -> void:
	_publish_pause_action(EventBus.UIEvent.PauseMenuAction.Action.SETTINGS)

func _on_restart_pressed() -> void:
	_publish_pause_action(EventBus.UIEvent.PauseMenuAction.Action.RESTART)

func _on_exit_pressed() -> void:
	# Usually "Exit" goes back to Title
	_publish_pause_action(EventBus.UIEvent.PauseMenuAction.Action.EXIT)

func _on_quit_pressed() -> void:
	# Usually "Quit" closes the desktop app
	_publish_pause_action(EventBus.UIEvent.PauseMenuAction.Action.QUIT)

# ===
# Local
# ===

func _publish_pause_action(action: EventBus.UIEvent.PauseMenuAction.Action) -> void:
	EventBus.publish(EventBus.UIEvent.PauseMenuAction.new(action))
