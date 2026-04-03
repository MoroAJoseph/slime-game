class_name UIController
extends Node

@export_group("Layers")
@onready var _hud: HUD = $HUD
@export var _menus_layer: CanvasLayer
@export var _loading_layer: CanvasLayer

@export_group("Elements")
@export var _main_menu: Control
@export var _pause_menu: Control

# ===
# Built-In
# ===

func _ready() -> void:
	_hide_all()
	EventBus.subscribe(_on_event)

# ===
# Local
# ===

func _hide_all() -> void:
	_hud.hide()
	_menus_layer.hide()
	_loading_layer.hide()
	_main_menu.hide()
	_pause_menu.hide()

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	# Gameplay
	if event is EventBus.GameplayEvent.GamePaused:
		_menus_layer.show()
		_pause_menu.show()
		_hud.hide()
	elif event is EventBus.GameplayEvent.GameResumed:
		_menus_layer.hide()
		_pause_menu.hide()
		_hud.show()
	elif event is EventBus.GameplayEvent.TitleLoaded:
		_hide_all()
		_menus_layer.show()
		_main_menu.show()
	elif event is EventBus.GameplayEvent.LevelLoaded:
		_hide_all()
		_hud.show()
	
	# UI
	elif event is EventBus.UIEvent.ToggleHud:
		_hud.visible = event.is_visible
	elif event is EventBus.UIEvent.ToggleLoading:
		_loading_layer.visible = event.is_visible
