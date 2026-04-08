class_name EndlessHubElevator
extends Node3D

enum Floor { ATRIUM, FORGE, BIO_LAB, RANGE }

@export var initial_floor: Floor
@export var atrium_marker: Marker3D
@export var forge_marker: Marker3D
@export var biolab_marker: Marker3D
@export var range_marker: Marker3D

@onready var STATE_MACHINE: StateMachine = $StateMachine
@onready var ANIMATION_PLAYER: AnimationPlayer = $AnimationPlayer
@onready var PLAYER_DETECTOR: PlayerDetector = $PlayerDetector
@onready var MENU: ElevatorMenu3D = $Menu3D
@onready var FLOOR_MAP: Dictionary = {
	Floor.ATRIUM: atrium_marker,
	Floor.FORGE: forge_marker,
	Floor.BIO_LAB: biolab_marker,
	Floor.RANGE: range_marker
}

# ===
# Built-In
# ===

func _ready() -> void:
	_setup_menu()
	_setup_states()

# ===
# Private
# ===

func _setup_menu() -> void:
	MENU.hide()
	
	var ui_2d = MENU.ui_menu
	if ui_2d:
		ui_2d.set_current_floor(initial_floor)

func _setup_states() -> void: 
	for child in STATE_MACHINE.get_children():
		if child is EndlessElevatorState:
			child.setup(self)
