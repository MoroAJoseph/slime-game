extends Control

@onready var _close_button: Button = %Close

# ===
# Built-In
# ===

func _ready() -> void:
	_close_button.pressed.connect(_on_close_pressed)

# ===
# Signals
# ===

func _on_close_pressed() -> void:
	UIEvent.ProvisionerMenu.new(UIEvent.ProvisionerMenuAction.CLOSE)
