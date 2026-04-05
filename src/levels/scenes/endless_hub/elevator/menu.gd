extends Control


signal floor_selected(index: int)

@export var buttons_container: Control

@onready var buttons = buttons_container.get_children()

# ===
# Built-In
# ===
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("2D CLICK: ", event.position)
		for b in buttons:
			# This will tell us the exact pixel-box of every button
			print("Button ", b.name, " Rect: ", b.get_global_rect())
			if b.get_global_rect().has_point(event.position):
				print("SUCCESS: Clicked ", b.name)

func _ready() -> void:
	for i in range(buttons.size()):
		var btn = buttons[i] as Button
		# If the editor already connected this, disconnect it to avoid the error
		if btn.pressed.is_connected(_on_button_pressed):
			btn.pressed.disconnect(_on_button_pressed)
			
		btn.pressed.connect(_on_button_pressed.bind(i))

# ===
# Public
# ===

func set_current_floor(current_idx: int) -> void:
	for i in range(buttons.size()):
		var btn = buttons[i] as Button
		if i == current_idx:
			btn.disabled = true
			# Makes the text stand out so it's clear why it's disabled
			btn.text = "[ CURRENT ]" 
		else:
			btn.disabled = false
			# Reset text to original names (or use a list of names)
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
