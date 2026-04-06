class_name DamageNumber
extends Control

@export var font_size: int = 52
@export var rise_speed: float = 80.0
@export var duration: float = 1.0
@export var horizontal_spread: float = 40.0

var _velocity: Vector2 = Vector2.ZERO
var _anim_offset: Vector2 = Vector2.ZERO
var _target_world_pos: Vector3
var _camera: Camera3D
var _label: Label

func spawn(value: float, world_pos: Vector3, camera: Camera3D) -> void:
	_camera = camera
	_target_world_pos = world_pos
	
	# 1. Create Label
	_label = Label.new()
	_label.text = str(abs(round(value)))
	
	# Settings
	var settings = LabelSettings.new()
	settings.font_size = font_size
	settings.outline_size = 6
	settings.outline_color = Color.BLACK
	_label.label_settings = settings
	
	add_child(_label)
	
	# IMPORTANT: Center the label's pivot so it scales from the middle
	# We wait a frame or call force_update to get the correct size
	_label.resized.connect(func(): _label.pivot_offset = _label.size / 2.0)
	
	# 2. Set Initial Physics
	_velocity = Vector2(randf_range(-horizontal_spread, horizontal_spread), -rise_speed)
	
	# 3. Start the Tween
	_animate()

func _process(delta: float) -> void:
	if not _camera:
		return

	# Update the relative floaty movement
	_anim_offset += _velocity * delta
	_velocity.y *= 0.95 # Slow down the rise over time
	
	# Calculate the 2D position from 3D world space
	if _camera.is_position_behind(_target_world_pos):
		visible = false
	else:
		visible = true
		var base_screen_pos = _camera.unproject_position(_target_world_pos)
		
		# LOCK: The position is exactly the 3D projection + the small 2D jitter/rise
		# We subtract label.size/2 so the text is centered on the point
		position = base_screen_pos + _anim_offset - (_label.size / 2.0)

func _animate() -> void:
	var tween = create_tween().set_parallel(true)
	
	# Scale effect (Pop)
	_label.scale = Vector2(0.5, 0.5)
	tween.tween_property(_label, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK)
	
	# Fade effect
	tween.tween_property(_label, "modulate:a", 0.0, duration).set_delay(duration * 0.5)
	
	# Cleanup
	tween.chain().tween_callback(queue_free)
