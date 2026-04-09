class_name TransitPod
extends Node3D

@onready var GAZE_SENSOR: GazeSensor = $GazeSensor
@onready var PLAYER_DETECTOR: PlayerDetector = $PlayerDetector
@onready var INTERACT_LABEL: Label3D = $InteractLabel

var _is_gazing: bool = false
var _is_player_nearby: bool = false

# ===
# Built-In
# ===

func _ready() -> void:
	GAZE_SENSOR.hovered.connect(_on_gaze_hovered)
	GAZE_SENSOR.unhovered.connect(_on_gaze_unhovered)
	
	PLAYER_DETECTOR.entered.connect(_on_player_entered)
	PLAYER_DETECTOR.exited.connect(_on_player_exited)
	
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

func _on_player_entered(_sensor: PlayerSensor) -> void:
	_is_player_nearby = true
	if _is_gazing:
		INTERACT_LABEL.show()

func _on_player_exited(_sensor: PlayerSensor) -> void:
	_is_player_nearby = false
	INTERACT_LABEL.hide()

func _on_interaction_received(data: InteractionData) -> void:
	WorldEvent.InteractionRequest.new(data)

func _on_gaze_hovered() -> void:
	_is_gazing = true
	if _is_player_nearby:
		INTERACT_LABEL.show()

func _on_gaze_unhovered() -> void:
	_is_gazing = false
	INTERACT_LABEL.hide()
	
