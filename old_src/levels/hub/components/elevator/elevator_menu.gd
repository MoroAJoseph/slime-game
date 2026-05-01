extends Menu3D

signal floor_selected(index: int)

# ===
# Private
# ===

func _setup():
	if _ui_menu:
		_ui_menu.floor_selected.connect(func(idx): floor_selected.emit(idx))
