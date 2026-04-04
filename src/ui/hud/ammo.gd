extends MarginContainer

@export var _current_node: Label
@export var _maximum_node: Label
@export var _percentage_bar: ProgressBar
@export var _reloading_node: Label

var _ammo_tween: Tween

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)
	_reloading_node.text = ""

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.PlayerEvent.AmmoUpdated:
		# Update text immediately for responsiveness
		_current_node.text = str(event.current)
		_maximum_node.text = str(event.maximum)
		
		# Calculate target percentage (0 to 100)
		var target_val: float = 0.0
		if event.maximum > 0:
			target_val = (float(event.current) / float(event.maximum)) * 100.0
		
		# Kill existing tween to prevent "fighting" during rapid fire
		if _ammo_tween and _ammo_tween.is_running():
			_ammo_tween.kill()
			
		_ammo_tween = create_tween()
		
		# Animate the progress bar value
		_ammo_tween.tween_property(_percentage_bar, "value", target_val, 0.2)\
			.set_trans(Tween.TRANS_QUINT)\
			.set_ease(Tween.EASE_OUT)
	
	elif event is EventBus.PlayerEvent.ReloadStarted:
		_reloading_node.text = "Reloading"
		
		# Bonus: Animate the bar filling up over the actual reload time
		if _ammo_tween and _ammo_tween.is_running():
			_ammo_tween.kill()
			
		_ammo_tween = create_tween()
		# Set bar to 0 first if it's empty, then fill to 100
		_ammo_tween.tween_property(_percentage_bar, "value", 100.0, event.duration)\
			.set_trans(Tween.TRANS_LINEAR)
	
	elif event is EventBus.PlayerEvent.ReloadFinished:
		_reloading_node.text = ""
