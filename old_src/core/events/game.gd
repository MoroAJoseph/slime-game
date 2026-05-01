class_name GameEvent
extends Event

class BootsplashFinished extends GameEvent:
	
	func _init():
		emit()

# ===
# Basic States
# ===

# --- Save ---
class SavingUpdated extends GameEvent:

	var value: bool
	
	func _init(_value: bool):
		value = _value
		emit()

# --- Load ---
class LoadingUpdated extends GameEvent:

	var value: bool
	
	func _init(_value: bool):
		value = _value
		emit()

# --- Paused ---
class PausedUpdated extends GameEvent:
	
	var value: bool
	
	func _init(_value: bool):
		value = _value
		emit()

# ===
# Inventory
# ===

class InventoryRequest extends GameEvent:
	enum Action { ADD, REMOVE }
	
	var data: Resource # Inventory Data
	var action: Action
	var item: Resource
	var amount: int
	
	func _init(_data: Resource, _action: Action, _item: Resource, _amount: int):
		data = _data
		action = _action
		item = _item
		amount = _amount
		emit()

class InventoryResponse extends GameEvent: 
	
	var initial_request: InventoryRequest
	var result: ResponseResult
	var message: String
	
	func _init(_initial_request: InventoryRequest, _result: ResponseResult, _message: String):
		initial_request = _initial_request
		result = _result
		message = _message
		emit()

class InventoryUpdated extends GameEvent:
	
	var data: Resource # Inventory Data
	
	func _init(_data: Resource):
		data = _data
		emit()
