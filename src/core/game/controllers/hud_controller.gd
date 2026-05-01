extends CanvasLayer

@onready var _safe: Control = $Safe
@onready var _expedition: Control = $Expedition

var _current: Control = null

# ===
# Built-In
# ===

func _ready() -> void:
	_hide_all()
	visible = true

# ===
# Public
# ===

func toggle(option: Constants.HUDOption, is_open: bool) -> void:
	var control = _get_control(option)
	if control:
		control.visible = is_open
		_current = control

func has_any_open() -> bool:
	for child in get_children():
		if child.visible:
			return true
	
	return false

func get_open() -> Control:
	for child in get_children():
		if child.visible:
			return child
	
	return null

# ===
# Private
# ===

func _hide_all() -> void:
	for child in get_children():
		child.hide()

func _get_control(option: Constants.HUDOption) -> Control:
	match option:
		Constants.HUDOption.SAFE: return _safe
		Constants.HUDOption.EXPEDITION: return _expedition
		_: return null
