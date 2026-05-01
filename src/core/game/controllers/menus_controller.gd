extends CanvasLayer

@onready var _hub: Control = $HUB
@onready var _expedition: Control = $Expedition

# ===
# Built-In
# ===

func _ready() -> void:
	_hide_all()
	visible = true

# ===
# Public
# ===

func toggle(option: Constants.HUDOption, is_visible: bool) -> void:
	var control = _get_control(option)
	if control:
		_toggle_logic(control, is_visible)

func has_any_open() -> bool:
	return _hub.visible or _expedition.visible

# ===
# Private
# ===

func _hide_all() -> void:
	_hub.hide()
	_expedition.hide()

func _get_control(option: Constants.HUDOption) -> Control:
	match option:
		Constants.HUDOption.HUB: return _hub
		Constants.HUDOption.EXPEDITION: return _expedition
	return null

func _toggle_logic(control: Control, is_visible: bool) -> void:
	control.visible = is_visible
