class_name ToWorld
extends Node3D

@onready var GAZE_SENSOR: GazeSensor = $GazeSensor
@onready var INTERACT_LABEL: Label3D = $InteractLabel

var _is_gazing: bool = false

# ===
# Built-In
# ===

func _ready() -> void:
	GAZE_SENSOR.hovered.connect(_on_gaze_hovered)
	GAZE_SENSOR.unhovered.connect(_on_gaze_unhovered)
	
	INTERACT_LABEL.hide()
	
	EventBus.subscribe(_on_event)

# ===
# Private
# ===

func _handle_interaction_success() -> void:
	print_debug("interacting")


# ===
# Events
# ===

func _on_event(event: Event) -> void:
	if event is WorldEvent.InteractionResponse:
		if event.initial_request.data.target == self:
			match event.result:
				Event.ResponseResult.SUCCESS:
					_handle_interaction_success()
				Event.ResponseResult.FAIL:
					pass

# ===
# Signals
# ===

func _on_gaze_hovered() -> void:
	_is_gazing = true
	INTERACT_LABEL.show()

func _on_gaze_unhovered() -> void:
	_is_gazing = false
	INTERACT_LABEL.hide()
	
