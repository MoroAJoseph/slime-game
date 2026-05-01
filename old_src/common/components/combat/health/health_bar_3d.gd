class_name HealthBar3D
extends Node3D

@export var _vertical_offset: float = 2.5
@export var _bar_scale: float = 1.0

@onready var _sub_viewport = $SubViewport
@onready var _sprite = $Sprite3D
@onready var _bar = $SubViewport/ProgressBar

# ===
# Built-In
# ===

func _process(_delta: float) -> void:
	_sprite.position.y = _vertical_offset
	_sprite.scale = Vector3.ONE * _bar_scale

# ===
# Local
# ===

func setup(max_health: float) -> void:
	_bar.max_value = max_health
	_bar.value = max_health
	
	_sprite.texture = _sub_viewport.get_texture()
	
	_sprite.position.y = _vertical_offset
	_sprite.scale = Vector3.ONE * _bar_scale

func update_health(current_health: float) -> void:
	var tween = create_tween()
	tween.tween_property(_bar, "value", current_health, 0.2).set_ease(Tween.EASE_OUT)
