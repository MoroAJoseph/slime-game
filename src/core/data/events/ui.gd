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
enum TitleMainAction { OPEN, CLOSE, SANDBOX, ENDLESS, EXIT, SETTINGS }

class TitleMain extends UIEvent:
	
	var action: TitleMainAction
	
	func _init(_action: TitleMainAction) -> void:
		action = _action
		emit()


# --- Settings ---
enum TitleSettingsAction { OPEN, CLOSE, BACK }

class TitleSettings extends UIEvent:
	
	var action: TitleSettingsAction
	
	func _init(_action: TitleSettingsAction) -> void:
		action = _action
		emit()

# ===
# Endless Hub
# ===

# --- Main ---
enum EndlessHubMainAction { OPEN, CLOSE, EXIT, QUIT }

class EndlessHubMain extends UIEvent:
	
	var action: EndlessHubMainAction
	
	func _init(_action: EndlessHubMainAction) -> void:
		action = _action
		emit()

# --- Inventory ---
enum EndlessHubInventoryAction { OPEN, CLOSE }

class EndlessHubInventory extends UIEvent:
	
	var action: EndlessHubInventoryAction
	
	func _init(_action: EndlessHubInventoryAction) -> void:
		action = _action
		emit()

# --- Dismantle ---
enum EndlessHubDismantlerAction { OPEN, CLOSE, DISMANTLE }

class EndlessHubDismantler extends UIEvent:
	
	var action: EndlessHubDismantlerAction
	
	func _init(_action: EndlessHubDismantlerAction) -> void:
		action = _action
		emit()

# --- Provisioner ---
enum EndlessHubProvisionerAction { OPEN, CLOSE, DISMANTLE }

class EndlessHubProvisioner extends UIEvent:
	
	var action: EndlessHubProvisionerAction
	
	func _init(_action: EndlessHubProvisionerAction) -> void:
		action = _action
		emit()

# ===
# Endless Expedition
# ===

# --- Pause ---
enum EndlessExpeditionPauseAction { OPEN, CLOSE, RESUME, SETTINGS, RESTART, EXIT, QUIT }

class EndlessExpeditionPause extends UIEvent:
	
	var action: EndlessExpeditionPauseAction
	
	func _init(_action: EndlessExpeditionPauseAction) -> void:
		action = _action
		emit()
