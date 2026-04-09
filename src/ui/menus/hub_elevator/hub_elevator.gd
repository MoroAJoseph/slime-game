extends Control

signal floor_selected(index: int)

@onready var _buttons = %Buttons.get_children()

# ===
# Built-In
# ===

func _ready() -> void:
	for i in range(_buttons.size()):
		var button = _buttons[i] as Button
		if button.pressed.is_connected(_on_button_pressed):
			button.pressed.disconnect(_on_button_pressed)
			
		button.pressed.connect(_on_button_pressed.bind(i))
	
	# TODO: Dynamically hide/show buttons based on player's progression

# ===
# Public
# ===

func set_current_floor(current_idx: int) -> void:
	for i in range(_buttons.size()):
		var button = _buttons[i] as Button
		if i == current_idx:
			button.disabled = true
			button.text = "[ Current Floor ]" 
		else:
			button.disabled = false
			button.text = _get_floor_name(i)

# ===
# Private
# ===

func _get_floor_name(index: int) -> String:
	var names = ["Atrium", "Forge", "Bio-Lab", "Range"]
	return names[index] if index < names.size() else "Unknown"


# ===
# Signals
# ===

func _on_button_pressed(idx: int):
	floor_selected.emit(idx)
