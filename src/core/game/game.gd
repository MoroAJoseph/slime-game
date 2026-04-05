class_name Game
extends Node

@export_file("*tscn") var title_level_path: String
@export_file("*.tscn") var sandbox_path: String
@export_file("*.tscn") var endless_hub_path: String

@onready var WORLD_CONTROLLER: WorldController = $WorldController
@onready var UI_CONTROLLER: UIController = $UIController
@onready var STATE_MACHINE: StateMachine = $StateMachine

func _ready() -> void:
	for child in STATE_MACHINE.get_children():
		if child is GameState:
			child.setup(self)
