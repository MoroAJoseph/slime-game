class_name UIEvent
extends Event

# ===
# HUD Toggles
# ===

class HUDToggle extends UIEvent:
	
	var is_visible: bool
	
	func _init(_is_visible: bool):
		is_visible = _is_visible
		emit()

# ===
# Title
# ===

# --- Main ---
enum MainMenuAction { OPEN, CLOSE, SANDBOX, PLAY, EXIT, SETTINGS }

class MainMenu extends UIEvent:
	
	var action: MainMenuAction
	
	func _init(_action: MainMenuAction) -> void:
		action = _action
		emit()


# --- Settings ---
enum TitleSettingsMenuAction { OPEN, CLOSE, BACK }

class TitleSettingsMenu extends UIEvent:
	
	var action: TitleSettingsMenuAction
	
	func _init(_action: TitleSettingsMenuAction) -> void:
		action = _action
		emit()

# ===
# Hub
# ===

# --- Inventory ---
enum InventoryMenuAction { OPEN, CLOSE }

class InventoryMenu extends UIEvent:
	
	var action: InventoryMenuAction
	
	func _init(_action: InventoryMenuAction) -> void:
		action = _action
		emit()

# --- Dismantle ---
enum DismantlerMenuAction { OPEN, CLOSE, DISMANTLE }

class DismantlerMenu extends UIEvent:
	
	var action: DismantlerMenuAction
	
	func _init(_action: DismantlerMenuAction) -> void:
		action = _action
		emit()

# --- Builer Bench ---
enum BuilderBenchMenuAction { OPEN, CLOSE }

class BuilderBenchMenu extends UIEvent:
	
	var action: BuilderBenchMenuAction
	
	func _init(_action: BuilderBenchMenuAction) -> void:
		action = _action
		emit()

# --- Provisioner ---
enum ProvisionerMenuAction { OPEN, CLOSE }

class ProvisionerMenu extends UIEvent:
	
	var action: ProvisionerMenuAction
	
	func _init(_action: ProvisionerMenuAction) -> void:
		action = _action
		emit()

# ===
# Endless Expedition
# ===

# --- Pause ---
enum PauseMenuAction { OPEN, CLOSE, RESUME, SETTINGS, EXIT, QUIT }

class PauseMenu extends UIEvent:
	
	var action: PauseMenuAction
	
	func _init(_action: PauseMenuAction) -> void:
		action = _action
		emit()
