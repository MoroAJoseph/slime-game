extends CenterContainer

@export_group("Config")
@export var _dot_radius: float = 2.0
@export var _dot_color: Color = Color.WHITE
@export var _base_spread: float = 10.0
@export var _max_spread: float = 50.0
@export var _lerp_speed: float = 10.0

var _current_spread: float = 10.0
var _target_spread: float = 10.0

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)
	_setup_lines()

func _process(delta: float) -> void:
	# Smoothly transition the spread
	_current_spread = lerp(_current_spread, _target_spread, _lerp_speed * delta)
	
	# Update positions relative to the center
	$Top.position = Vector2(0, -_current_spread)
	$Bottom.position = Vector2(0, _current_spread)
	$Left.position = Vector2(-_current_spread, 0)
	$Right.position = Vector2(_current_spread, 0)

# ===
# Local
# ===

func _setup_lines() -> void:
	# Define a small 10px line for each reticle segment
	# We center the points so the Line2D's local (0,0) is its middle
	var line_length = 10.0
	$Top.points = [Vector2(0, -line_length), Vector2(0, 0)]
	$Bottom.points = [Vector2(0, 0), Vector2(0, line_length)]
	$Left.points = [Vector2(-line_length, 0), Vector2(0, 0)]
	$Right.points = [Vector2(0, 0), Vector2(line_length, 0)]

func _draw() -> void:
	draw_circle(Vector2.ZERO, _dot_radius, _dot_color)

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.PlayerEvent.AimStarted:
		match event.type:
			event.Type.HIP:
				_target_spread = _base_spread * 0.5
			event.Type.SCOPE:
				_target_spread = 0.0
	elif event is EventBus.PlayerEvent.AimFinished:
		_target_spread = _base_spread
	elif event is EventBus.PlayerEvent.FiredGun:
		_current_spread += 20.0 
		_current_spread = clamp(_current_spread, 0, _max_spread)
