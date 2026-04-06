class_name PlayerDetector
extends Area3D

signal player_entered(player: Player)
signal player_exited(player: Player)

# ===
# Built-In
# ===

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# ===
# Signals
# ===

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		player_entered.emit(body)

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		player_exited.emit(body)
