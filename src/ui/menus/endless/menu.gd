extends Control

# ===
# Signals
# ===

# --- Button ---
func _on_close_pressed() -> void:
	_publish_action(EventBus.UIEvent.EndlessHubMenuAction.Action.CLOSE)

func _on_exit_pressed() -> void:
	_publish_action(EventBus.UIEvent.EndlessHubMenuAction.Action.EXIT)

func _on_quit_pressed() -> void:
	_publish_action(EventBus.UIEvent.EndlessHubMenuAction.Action.QUIT)

# ===
# Private
# ===

func _publish_action(action: EventBus.UIEvent.EndlessHubMenuAction.Action) -> void:
	EventBus.publish(EventBus.UIEvent.EndlessHubMenuAction.new(action))
