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
	_current_spread = lerp(_current_spread, _target_spread, _lerp_speed * delta)
	
	# Update positions relative to the center
	$Top.position = Vector2(0, -_current_spread)
	$Bottom.position = Vector2(0, _current_spread)
	$Left.position = Vector2(-_current_spread, 0)
	$Right.position = Vector2(_current_spread, 0)

# ===
# Private
# ===

func _setup_lines() -> void:
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

func _on_event(event: Event) -> void:
	# Weapon Aim
	if event is WeaponEvent.AimUpdated:
		match event.state:
			
			# Started
			WeaponEvent.AimState.STARTED:
				_target_spread = _base_spread * 0.5
			
			# Aiming
			WeaponEvent.AimState.AIMING:
				# aimed sway
				pass
			
			# Stopping
			WeaponEvent.AimState.STOPPING:
				pass
			
			# Finished
			WeaponEvent.AimState.FINISHED:
				# hip sway
				_target_spread = _base_spread
	
	# Weapon Action
	elif event is WeaponEvent.Action:
		match event.action:
			
			# Primary: Fire
			WeaponEvent.ActionType.PRIMARY:
				_current_spread += 20.0 
				_current_spread = clamp(_current_spread, 0, _max_spread)
