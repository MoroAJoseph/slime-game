class_name Game
extends Node

@onready var WORLD_CONTROLLER: WorldController = $WorldController
@onready var UI_CONTROLLER: UIController = $UIController
@onready var STATE_MACHINE: StateMachine = $StateMachine

func _ready() -> void:
	for child in STATE_MACHINE.get_children():
		if child is GameState:
			child.setup(self)
