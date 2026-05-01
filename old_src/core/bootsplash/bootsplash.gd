class_name Bootsplash
extends Node

# ===
# Built-In
# ===

func _ready() -> void:
	get_tree().create_timer(1.0).timeout.connect(_on_timer_timeout)

# ===
# Signals
# ===

func _on_timer_timeout() -> void:
	GameEvent.BootsplashFinished.new()
