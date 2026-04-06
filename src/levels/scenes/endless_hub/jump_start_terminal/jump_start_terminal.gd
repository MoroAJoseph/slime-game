extends Node3D

@onready var PLAYER_DETECTOR: PlayerDetector = $PlayerDetector
@onready var INTERACT_LABEL: Label3D = $InteractLabel

var _player_detected: bool = false

# ===
# Built-In
# ===

func _ready() -> void:
	PLAYER_DETECTOR.player_entered.connect(_on_player_entered)
	PLAYER_DETECTOR.player_exited.connect(_on_player_exited)
	INTERACT_LABEL.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_interact") and _player_detected:
		print_debug("TODO: Use Jump-Start Terminal")

# ===
# Signals
# ===

func _on_player_entered(_player: Player) -> void:
	_player_detected = true
	INTERACT_LABEL.show()

func _on_player_exited(_player: Player) -> void:
	_player_detected = false
	INTERACT_LABEL.hide()
