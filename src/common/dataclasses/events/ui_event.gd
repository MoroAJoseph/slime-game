class_name UIEvent
extends Event

# ===
# HUD
# ===

class HUDToggle extends UIEvent:
	
	var is_visible: bool
	
	func _init(_is_visible: bool):
		is_visible = _is_visible
		emit()

# ===
# Title Menu
# ===

# --- Main ---
enum MainMenuAction { OPEN, CLOSE, SANDBOX, PLAY, EXIT, SETTINGS }

class MainMenu extends UIEvent:
	
	var action: MainMenuAction
	
	func _init(_action: MainMenuAction) -> void:
		action = _action
		emit()

# ===
# World Menu
# ===
