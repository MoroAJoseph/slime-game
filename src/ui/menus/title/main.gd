extends Control

# ===
# Signals
# ===

func _on_sandbox_pressed() -> void:
	UIEvent.TitleMain.new(UIEvent.TitleMainAction.SANDBOX)

func _on_endless_pressed() -> void:
	UIEvent.TitleMain.new(UIEvent.TitleMainAction.ENDLESS)

func _on_settings_pressed() -> void:
	UIEvent.TitleMain.new(UIEvent.TitleMainAction.SETTINGS)

func _on_exit_pressed() -> void:
	UIEvent.TitleMain.new(UIEvent.TitleMainAction.EXIT)
