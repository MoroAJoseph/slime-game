extends Menu3D

signal activated

# ===
# Private
# ===

func _setup() -> void:
	_ui_menu.activated.connect(func(): activated.emit())
