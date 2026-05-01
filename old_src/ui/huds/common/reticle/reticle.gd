extends CenterContainer

enum ReticleStyle { CROSS, CIRCLE, TRIANGLE }

@export_group("General Config")
@export var _style: ReticleStyle = ReticleStyle.TRIANGLE
@export var _dot_radius: float = 1.5
@export var _color: Color = Color.WHITE
@export var _lerp_speed: float = 12.0

@export_group("Spread Config")
@export var _base_spread: float = 20.0
@export var _zoomed_spread: float = 8.0
@export var _max_spread: float = 60.0

@export_group("Visual Flair")
@export var _max_spin_angle: float = 90.0 # Used for Circle

var _current_spread: float = 20.0
var _target_spread: float = 20.0
var _is_aiming: bool = false
var _is_reloading: bool = false

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)

func _process(delta: float) -> void:
	_current_spread = lerp(_current_spread, _target_spread, _lerp_speed * delta)
	queue_redraw()

func _draw() -> void:
	# We use modulate.a for the fade, so we can still draw here.
	# But if you want to skip drawing entirely when alpha is 0:
	if modulate.a <= 0.0: return

	draw_circle(Vector2.ZERO, _dot_radius, _color)
	
	match _style:
		ReticleStyle.CROSS:
			_draw_cross_reticle()
		ReticleStyle.CIRCLE:
			_draw_circle_reticle()
		ReticleStyle.TRIANGLE:
			_draw_triangle_reticle()

# ===
# Draw Logic
# ===

func _draw_triangle_reticle() -> void:
	var tri_side: float = 6.0 
	var h: float = (sqrt(3) / 2.0) * tri_side 
	var centroid_to_top: float = (2.0 / 3.0) * h
	var centroid_to_bottom: float = (1.0 / 3.0) * h
	
	var offset = _current_spread
	var centers = [
		Vector2(0, -offset),
		Vector2(offset * cos(deg_to_rad(30)), offset * sin(deg_to_rad(30))),
		Vector2(-offset * cos(deg_to_rad(30)), offset * sin(deg_to_rad(30)))
	]
	
	for center in centers:
		var p1 = center + Vector2(0, -centroid_to_top)
		var p2 = center + Vector2(-tri_side / 2.0, centroid_to_bottom)
		var p3 = center + Vector2(tri_side / 2.0, centroid_to_bottom)
		
		var tri_points = PackedVector2Array([p1, p2, p3])
		var alpha = 1.0 if _is_aiming else 0.7
		var draw_color = Color(_color.r, _color.g, _color.b, alpha)
		
		draw_colored_polygon(tri_points, draw_color)

func _draw_cross_reticle() -> void:
	var line_len = 8.0
	var thickness = 2.0
	var offset = _current_spread
	draw_line(Vector2(0, -offset), Vector2(0, -offset - line_len), _color, thickness)
	draw_line(Vector2(0, offset), Vector2(0, offset + line_len), _color, thickness)
	draw_line(Vector2(-offset, 0), Vector2(-offset - line_len, 0), _color, thickness)
	draw_line(Vector2(offset, 0), Vector2(offset + line_len, 0), _color, thickness)

func _draw_circle_reticle() -> void:
	var radius = _current_spread + 5.0
	var thickness = 2.5
	var segment_count = 3
	var gap_size = deg_to_rad(40)
	
	var t = clamp(remap(_current_spread, _base_spread, _zoomed_spread, 0.0, 1.0), 0.0, 1.0)
	var rotation_offset = deg_to_rad(t * _max_spin_angle)
	
	var full_circle = PI * 2
	var arc_len = (full_circle / segment_count) - gap_size
	
	for i in range(segment_count):
		var start_angle = (i * (full_circle / segment_count)) + rotation_offset
		draw_arc(Vector2.ZERO, radius, start_angle, start_angle + arc_len, 32, _color, thickness, true)

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	if event is WeaponEvent.AimUpdated:
		match event.state:
			WeaponEvent.AimState.STARTED:
				_is_aiming = true
				_target_spread = _zoomed_spread
			WeaponEvent.AimState.FINISHED:
				_is_aiming = false
				_target_spread = _base_spread
				
	elif event is WeaponEvent.Action:
		if event.action == WeaponEvent.ActionType.PRIMARY and not _is_reloading:
			_current_spread += 15.0
			_current_spread = clamp(_current_spread, 0, _max_spread)

	elif event is WeaponEvent.ReloadUpdated:
		match event.state:
			WeaponEvent.ReloadState.STARTED:
				_is_reloading = true
				create_tween().tween_property(self, "modulate:a", 0.0, 0.1)
			
			WeaponEvent.ReloadState.FINISHED, WeaponEvent.ReloadState.INTERRUPTED:
				_is_reloading = false
				create_tween().tween_property(self, "modulate:a", 1.0, 0.1)
