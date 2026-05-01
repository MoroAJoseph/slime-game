class_name PlayerInteractionController
extends Node

@export var detector: InteractableDetector

@onready var player: Player = get_parent()

var _current_gaze_sensor: GazeSensor = null

# ===
# Built-In
# ===

func _process(_delta: float) -> void:
	_update_gaze()

# ===
# Public
# ===

func attempt_interact() -> void:
	# Precision Gaze
	if _current_gaze_sensor and _current_gaze_sensor.is_interactable:
		var data = InteractionData.new(player, _current_gaze_sensor.owner)
		WorldEvent.InteractionRequest.new(data)
		return
	
	# Proximity Fallback
	detector.interact()

# ===
# Private
# ===

func _update_gaze() -> void:
	var result = player.get_viewport_raycast_data(15.0)
	var hit_collider = result.get("collider")
	var hit_pos = result.get("position", player.global_position)
	var dist = player.global_position.distance_to(hit_pos)
	var new_sensor: GazeSensor = null
	
	# Validation Logic
	if hit_collider is GazeSensor:
		if hit_collider.notify_hover(dist):
			new_sensor = hit_collider

	# State Management
	if new_sensor != _current_gaze_sensor:
		if _current_gaze_sensor: 
			_current_gaze_sensor.notify_unhover()
		_current_gaze_sensor = new_sensor

	# Notification Logic
	var gaze_color = Color.WHITE
	if _current_gaze_sensor: 
		gaze_color = _current_gaze_sensor.get_current_gaze_color()
	
	var gaze_target_data = GazeTargetData.new(
		_current_gaze_sensor, 
		hit_pos, 
		dist, 
		gaze_color
	)
	
	PlayerEvent.GazeTargetUpdated.new(gaze_target_data)
