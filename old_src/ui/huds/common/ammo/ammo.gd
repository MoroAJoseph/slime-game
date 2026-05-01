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

func _on_event(event: Event) -> void:
	
	# Resource Update
	if event is WeaponEvent.ResourceUpdated:
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
	
	# Reload Update
	elif event is WeaponEvent.ReloadUpdated:
		match event.state:
			
			# Started
			WeaponEvent.ReloadState.STARTED:
				_reloading_node.text = "Reloading"
		
				if _ammo_tween and _ammo_tween.is_running():
					_ammo_tween.kill()
					
				_ammo_tween = create_tween()
				_ammo_tween.tween_property(_percentage_bar, "value", 100.0, event.duration)\
					.set_trans(Tween.TRANS_LINEAR)
			
			# Finished
			WeaponEvent.ReloadState.FINISHED:
				_reloading_node.text = ""
			
			# Interrupted
			WeaponEvent.ReloadState.INTERRUPTED:
				pass
