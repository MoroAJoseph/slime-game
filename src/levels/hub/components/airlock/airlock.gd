class_name HubAirlock
extends Node3D

@onready var _player_detector: PlayerDetector = $PlayerDetector
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _menu: Menu3D = $Menu3D

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
