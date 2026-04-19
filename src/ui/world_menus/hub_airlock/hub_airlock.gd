extends Control

signal activated

@onready var _activate_button: Button = %Activate

# ===
# Built-In
# ===

func _ready() -> void:
	_activate_button.pressed.is_connected(_on_activate_pressed)

# ===
# Public
# ===


# ===
# Signals
# ===

func _on_activate_pressed() -> void:
	activated.emit()
