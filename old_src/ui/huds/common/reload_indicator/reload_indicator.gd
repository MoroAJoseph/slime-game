class_name ReloadIndicator
extends CenterContainer

@export_group("Visuals")
@export var _radius: float = 30.0
@export var _thickness: float = 4.0
@export var _bg_color: Color = Color(0, 0, 0, 0.3)
@export var _progress_color: Color = Color.WHITE
@export var _interrupted_color: Color = Color.RED

var _progress: float = 0.0
var _is_reloading: bool = false
var _active_tween: Tween

# ===
# Built-In
# ===

func _ready() -> void:
	modulate.a = 0.0
	EventBus.subscribe(_on_event)

func _process(_delta: float) -> void:
	if _is_reloading:
		queue_redraw()

func _draw() -> void:
	if not _is_reloading:
		return

	# Background Ring
	draw_arc(Vector2.ZERO, _radius, 0, TAU, 64, _bg_color, _thickness, true)

	# Progress Ring
	var start_angle = -PI / 2.0
	var end_angle = start_angle + (TAU * _progress)
	
	draw_arc(Vector2.ZERO, _radius, start_angle, end_angle, 64, _progress_color, _thickness, true)

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	if event is WeaponEvent.ReloadUpdated:
		match event.state:
			WeaponEvent.ReloadState.STARTED:
				_start_reload(event.duration)
			
			WeaponEvent.ReloadState.FINISHED:
				_finish_reload()
			
			WeaponEvent.ReloadState.INTERRUPTED:
				_interrupt_reload()
	
	elif event is WeaponEvent.ResourceUpdated:
		_handle_resource_update(event.current, event.maximum)

# ===
# Private
# ===

func _start_reload(duration: float) -> void:
	if _active_tween: _active_tween.kill()
	
	_is_reloading = true
	_progress = 0.0
	_progress_color = Color.WHITE
	
	_active_tween = create_tween().set_parallel(true)
	_active_tween.tween_property(self, "modulate:a", 1.0, 0.1)
	_active_tween.tween_property(self, "_progress", 1.0, duration)

func _finish_reload() -> void:
	if _active_tween: _active_tween.kill()
	
	var finish_tween = create_tween().set_parallel(true)
	finish_tween.tween_property(self, "modulate:a", 0.0, 0.2).set_delay(0.1)
	finish_tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	finish_tween.finished.connect(func(): 
		_is_reloading = false
		scale = Vector2.ONE
	)

func _interrupt_reload() -> void:
	if _active_tween: _active_tween.kill()
	
	_progress_color = _interrupted_color
	var fail_tween = create_tween()
	fail_tween.tween_property(self, "modulate:a", 0.0, 0.15)
	fail_tween.finished.connect(func(): _is_reloading = false)

func _handle_resource_update(current: int, _maximum: int) -> void:
	# Optional: Flash the ring or show a static low-ammo state
	# Deadlock often pulses the UI when you're empty
	if current == 0 and not _is_reloading:
		# Trigger a small "Empty" shake or color pulse here if desired
		pass
