class_name Game
extends Node

@onready var _world_controller: WorldController = $WorldController
@onready var _ui_controller: UIController = $UIController
@onready var _state_machine: StateMachine = $StateMachine

# ===
# Built-In
# ===

# ===
# Public
# ===

func get_ui_controller() -> UIController:
	return _ui_controller

func get_world_controller() -> WorldController:
	return _world_controller
