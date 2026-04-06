extends Control

# ===
# Signals
# ===

# --- Button ---
func _on_sandbox_pressed() -> void:
	_publish_menu_action(EventBus.UIEvent.MainMenuAction.Action.SANDBOX)

func _on_endless_pressed() -> void:
	_publish_menu_action(EventBus.UIEvent.MainMenuAction.Action.ENDLESS)

func _on_settings_pressed() -> void:
	_publish_menu_action(EventBus.UIEvent.MainMenuAction.Action.SETTINGS)

func _on_exit_pressed() -> void:
	# TODO: Trigger "Screen Shutdown" animation here before publishing
	_publish_menu_action(EventBus.UIEvent.MainMenuAction.Action.EXIT)

# ===
# Local
# ===

func _publish_menu_action(action: EventBus.UIEvent.MainMenuAction.Action) -> void:
	var event = EventBus.UIEvent.MainMenuAction.new(action)
	EventBus.publish(event)
