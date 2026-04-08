class_name WorldEvent
extends Event

# ===
# Level
# ===

class LevelLoadRequest extends WorldEvent:
	
	var path: String
	var data: Resource # Level Data
	var is_only_child: bool
	
	func _init(_path: String, _data: Resource, _is_only_child: bool):
		path = _path
		data = _data
		is_only_child = _is_only_child
		emit()

class LevelLoadResponse extends WorldEvent:
	
	var initial_request: LevelLoadRequest
	var result: ResponseResult
	var message: String
	
	func _init(_initial_request: LevelLoadRequest, _result: ResponseResult, _message: String):
		initial_request = _initial_request
		result = _result
		message = _message
		emit()

class LevelReady extends WorldEvent:
	
	var level_node: Node3D
	
	func _init(_level_node: Node3D):
		level_node = _level_node
		emit()

# ===
# Entity
# ===

# --- Spawn ---
class EntitySpawnRequest extends WorldEvent:
	
	var scene: PackedScene
	var data: Resource
	var transform: Transform3D
	
	func _init(_scene: PackedScene, _data: Resource, _transform: Transform3D):
		scene = _scene
		data = _data
		transform = _transform
		emit()

class EntitySpawnResponse extends WorldEvent:
	
	var initial_request: EntitySpawnRequest
	var result: ResponseResult
	var message: String
	
	func _init(_initial_request: EntitySpawnRequest, _result: ResponseResult, _message: String):
		initial_request = _initial_request
		result = _result
		message = _message
		emit()

class EntitySpawned extends WorldEvent:
	
	var node: Node3D
	
	func _init(_node: Node3D):
		node = _node
		emit()

# --- Die ---
class EntityDieRequest extends WorldEvent:
	
	var node: Node3D
	
	func _init(_node: Node3D):
		node = _node
		emit()

class EntityDieResponse extends WorldEvent:
	
	var initial_request: EntityDieRequest
	var result: ResponseResult
	var message: String
	
	func _init(_initial_request: EntityDieRequest, _result: ResponseResult, _message: String):
		initial_request = _initial_request
		result = _result
		message = _message
		emit()

class EntityDied extends WorldEvent:
	
	var node: Node3D
	
	func _init(_node: Node3D):
		node = _node
		emit()

# ===
# Area Detection
# ===

# --- Interaction ---

enum InteractionState { STARTED, STOPPED }

class InteractionRequest extends GameEvent: 
	
	var data: InteractionData
	
	func _init(_data: InteractionData):
		data = _data
		emit()

class InteractionResponse extends GameEvent:
	
	var initial_request: InteractionRequest
	var result: ResponseResult
	var message: String
	
	func _init(_initial_request: InteractionRequest, _result: ResponseResult, _message: String):
		initial_request = _initial_request
		result = _result
		message = _message
		emit()

class InteractionInputUpdated extends GameEvent: 
	
	var state: InteractionState
	
	func _init(_state: InteractionState):
		state = _state
		emit()

# --- Damage ---
