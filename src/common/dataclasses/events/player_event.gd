class_name PlayerEvent
extends Event

# ===
# Aiming
# ===

enum AimState { STARTED, AIMING, STOPPING, FINISHED }

class AimUpdated extends PlayerEvent:
	
	var state: AimState
	
	func _init(_state: AimState):
		state = _state
		emit()

class GazeTargetUpdated extends PlayerEvent:
	
	var data: GazeTargetData
	
	func _init(_data: GazeTargetData):
		data = _data
		emit()
