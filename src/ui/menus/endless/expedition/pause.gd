extends Control

# ===
# Signals
# ===

func _on_resume_pressed() -> void:
	UIEvent.EndlessExpeditionPause.new(UIEvent.EndlessExpeditionPauseAction.RESUME)

func _on_settings_pressed() -> void:
	UIEvent.EndlessExpeditionPause.new(UIEvent.EndlessExpeditionPauseAction.SETTINGS)

func _on_restart_pressed() -> void:
	UIEvent.EndlessExpeditionPause.new(UIEvent.EndlessExpeditionPauseAction.RESTART)

func _on_exit_pressed() -> void:
	UIEvent.EndlessExpeditionPause.new(UIEvent.EndlessExpeditionPauseAction.EXIT)

func _on_quit_pressed() -> void:
	UIEvent.EndlessExpeditionPause.new(UIEvent.EndlessExpeditionPauseAction.QUIT)
