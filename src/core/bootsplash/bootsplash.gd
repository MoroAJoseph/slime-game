class_name Bootsplash
extends Node

# ===
# Built-In
# ===

func _ready() -> void:
	get_tree().create_timer(1.0).timeout.connect(_on_timer_timeout)

# ===
# Local
# ===

func _on_timer_timeout() -> void:
	EventBus.publish(EventBus.BootsplashFinished.new())
