class_name Game
extends Node

@onready var _state_machine: StateMachine = %StateMachine
@onready var _world: Node3D = %World
@onready var _hud: CanvasLayer = %HUD
@onready var _menus: CanvasLayer = %Menus
@onready var _loading: CanvasLayer = %Loading

# ===
# Built-In
# ===

# ===
# Public
# ===

func get_world() -> Node3D:
	return _world

func get_hud() -> CanvasLayer:
	return _hud

func get_menus() -> CanvasLayer:
	return _menus

func get_loading() -> CanvasLayer:
	return _loading
