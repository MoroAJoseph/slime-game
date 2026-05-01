class_name WorldEvent
extends Event

# ===
# Level
# ===

class LevelLoadRequest extends WorldEvent:
	
	var path: String
	var data: Resource
	var is_only_child: bool
	
	func _init(_path: String, _data: Resource, _is_only_child: bool):
		path = _path
		data = _data
		is_only_child = _is_only_child
		emit()

class LevelLoadResponse extends WorldEvent:
	
	var request: LevelLoadRequest
	var result: ResponseResult
	var message: String
	
	func _init(_request: LevelLoadRequest, _result: ResponseResult, _message: String):
		request = _request
		result = _result
		message = _message
		emit()

class LevelLoadNotify extends WorldEvent:
	
	var node: Node3D
	
	func _init(_node: Node3D):
		node = _node
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
	
	var request: EntitySpawnRequest
	var result: ResponseResult
	var message: String
	
	func _init(_request: EntitySpawnRequest, _result: ResponseResult, _message: String):
		request = _request
		result = _result
		message = _message
		emit()

class EntitySpawnNotify extends WorldEvent:
	
	var node: Node3D
	
	func _init(_node: Node3D):
		node = _node
		emit()

# --- Kill ---
class EntityKillRequest extends WorldEvent:
	
	var node: Node3D
	
	func _init(_node: Node3D):
		node = _node
		emit()

class EntityKillResponse extends WorldEvent:
	
	var request: EntityDieRequest
	var result: ResponseResult
	var message: String
	
	func _init(_request: EntityDieRequest, _result: ResponseResult, _message: String):
		request = _request
		result = _result
		message = _message
		emit()

class EntityKillNotify extends WorldEvent:
	
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
	
	var request: EntityDieRequest
	var result: ResponseResult
	var message: String
	
	func _init(_request: EntityDieRequest, _result: ResponseResult, _message: String):
		request = _request
		result = _result
		message = _message
		emit()

class EntityDieNotify extends WorldEvent:
	
	var node: Node3D
	
	func _init(_node: Node3D):
		node = _node
		emit()

# ===
# Interaction
# ===
