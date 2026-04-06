extends Control

signal floor_selected(index: int)

@onready var BUTTONS_CONTAINER: VBoxContainer = %Buttons

@onready var buttons = BUTTONS_CONTAINER.get_children()

# ===
# Built-In
# ===

func _ready() -> void:
	for i in range(buttons.size()):
		var btn = buttons[i] as Button
		if btn.pressed.is_connected(_on_button_pressed):
			btn.pressed.disconnect(_on_button_pressed)
			
		btn.pressed.connect(_on_button_pressed.bind(i))
	
	# TODO: Dynamically hide/show buttons based on player's progression

# ===
# Public
# ===

func set_current_floor(current_idx: int) -> void:
	for i in range(buttons.size()):
		var btn = buttons[i] as Button
		if i == current_idx:
			btn.disabled = true
			btn.text = "[ Current Floor ]" 
		else:
			btn.disabled = false
			btn.text = _get_floor_name(i)

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
	print("Floor selected: ", idx)
	floor_selected.emit(idx)
