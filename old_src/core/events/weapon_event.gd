class_name WeaponEvent
extends Event

# ===
# Action
# ===

enum ActionType { PRIMARY, SECONDARY, TERTIARY }

class Action extends WeaponEvent: 
	
	var action: ActionType
	
	func _init(_action: ActionType):
		action = _action
		emit()

# ===
# Aiming
# ===

enum AimState { STARTED, AIMING, STOPPING, FINISHED }

class AimUpdated extends WeaponEvent:
	
	var state: AimState
	
	func _init(_state: AimState):
		state = _state
		emit()

# ===
# Resources
# ===

enum ReloadState { STARTED, FINISHED, INTERRUPTED }

class ReloadUpdated extends WeaponEvent:
	
	var state: ReloadState
	var duration: float
	
	func _init(_state: ReloadState, _duration: float = 0.0):
		state = _state
		duration = _duration
		emit()

class ResourceUpdated extends WeaponEvent: 
	
	var current: int
	var maximum: int
	
	func _init(_current: int, _maximum: int):
		current = _current
		maximum = _maximum
		emit()
