class_name HealthBar3D
extends Node3D

@onready var viewport = $SubViewport
@onready var sprite = $Sprite3D
@onready var progress_bar = $SubViewport/ProgressBar

@export var vertical_offset: float = 2.5
@export var bar_scale: float = 1.0

# ===
# Built-In
# ===

func _process(_delta: float) -> void:
	sprite.position.y = vertical_offset
	sprite.scale = Vector3.ONE * bar_scale

# ===
# Local
# ===

func setup(max_health: float) -> void:
	progress_bar.max_value = max_health
	progress_bar.value = max_health
	
	sprite.texture = viewport.get_texture()
	
	sprite.scale = Vector3.ONE * bar_scale
	sprite.position.y = vertical_offset

func update_health(current_health: float) -> void:
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", current_health, 0.2).set_ease(Tween.EASE_OUT)
