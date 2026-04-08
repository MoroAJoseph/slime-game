class_name PlayerDetector
extends Area3D

signal entered(player: Player)
signal exited(player: Player)

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
		entered.emit(body)

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		exited.emit(body)
