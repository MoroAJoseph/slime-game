class_name PlayerEvent
extends Event


# ===
# Raycasts
# ===

class GazeTargetUpdated extends PlayerEvent:
	
	var data: GazeTargetData
	
	func _init(_data: GazeTargetData):
		data = _data
		emit()

# ===
# Input
# ===

class InputToggled extends PlayerEvent:
	
	var value: bool
	
	func _init(_value: bool):
		value = _value
		emit()

# ===
# Loadout
# ===

class LoadoutRequest extends PlayerEvent: 
	
	var loadout_data: PlayerLoadoutData 
	
	func _init(_loadout_data: PlayerLoadoutData):
		loadout_data = _loadout_data
		emit()

class LoadoutResponse extends PlayerEvent:
	
	var initial_request: LoadoutRequest
	var result: ResponseResult
	var message: String
	
	func _init(_initial_request: LoadoutRequest, _result: ResponseResult, _message: String) -> void:
		initial_request = _initial_request
		result = _result
		message = _message
		emit()
