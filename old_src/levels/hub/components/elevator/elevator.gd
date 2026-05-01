class_name HubElevator
extends Node3D

enum Floor { ATRIUM, FORGE, BIO_LAB, RANGE }

@export var initial_floor: Floor
@export var atrium_marker: Marker3D
@export var forge_marker: Marker3D
@export var biolab_marker: Marker3D
@export var range_marker: Marker3D

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _player_detector: PlayerDetector = $PlayerDetector
@onready var _menu: Menu3D = $Menu3D
@onready var _floor_map: Dictionary = {
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

# ===
# Private
# ===

func _setup_menu() -> void:
	_menu.hide()
	
	var ui_2d = _menu._ui_menu
	if ui_2d:
		ui_2d.set_current_floor(initial_floor)
