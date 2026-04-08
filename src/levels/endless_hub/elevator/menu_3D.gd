class_name ElevatorMenu3D
extends Menu3D

signal floor_selected(index: int)

# ===
# Parent
# ===

func _setup():
	if ui_menu:
		ui_menu.floor_selected.connect(func(idx): floor_selected.emit(idx))
	
