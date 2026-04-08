extends Control

# ===
# Signals
# ===

func _on_close_pressed() -> void:
	UIEvent.EndlessHubMain.new(UIEvent.EndlessHubMainAction.CLOSE)

func _on_exit_pressed() -> void:
	UIEvent.EndlessHubMain.new(UIEvent.EndlessHubMainAction.EXIT)

func _on_quit_pressed() -> void:
	UIEvent.EndlessHubMain.new(UIEvent.EndlessHubMainAction.QUIT)
