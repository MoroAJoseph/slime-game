extends Node

signal raised(event: Event)

# ===
# Events
# ===

class Event extends RefCounted: pass
class BootsplashFinished extends Event: pass

# --- Gameplay ---
class GameplayEvent:
	# Global Transitions
	class BootsplashFinished extends Event: pass
	class TitleLoaded extends Event: pass
	class LevelLoaded extends Event:
		var data: LevelData
		func _init(_data: LevelData): 
			data = _data
			
	# State Notifications
	class GamePaused extends Event: pass
	class GameResumed extends Event: pass
	
	# Hub Interactions (Still useful for specific world-to-logic triggers)
	class HubAction extends Event:
		enum Action { LAUNCH_RUN, OPEN_FORGE, OPEN_VAULT }
		var action: Action
		var level_path: String
		func _init(_action: Action, _path: String = ""):
			action = _action
			level_path = _path

# --- Player ---
class PlayerEvent:
	# - Actions -
	
	# Loadout
	class RequestWeaponSwap extends Event: pass
	
	# Gun
	class RequestReload extends Event: pass
	
	# - Notifications -
	
	# General
	class LookAtTargetUpdated extends Event:
		var result: Dictionary
		func _init(_result: Dictionary):
			result = _result
	class InputToggled extends Event:
		var value: bool
		func _init(_value: bool):
			value = _value
	class Died extends Event: pass
	class Spawned extends Event: 
		var player: Player
		func _init(_player: Player):
			player = _player
	
	# Loadout
	class WeaponSwapped extends Event: 
		func _init():
			pass
	
	# Gun
	class AimStarted extends Event: 
		enum Type { HIP, SCOPE }
		var type: Type
		func _init(_type: Type) -> void:
			type = _type
	class AimFinished extends Event: pass
	class FiredGun extends Event:
		var gun_data: GunData
		func _init(_gun_data: GunData):
			gun_data = _gun_data
	class ReloadStarted extends Event:
		var duration: float
		func _init(_duration: float): 
			duration = _duration
	class ReloadFinished extends Event: pass
	class AmmoUpdated extends Event:
		var current: int
		var maximum: int
		func _init(_current: int, _maximum: int): 
			current = _current
			maximum = _maximum
	
	# Sword

# --- UI ---
class UIEvent:
	class ToggleMinimapRotation extends Event:
		var value: bool
		func _init(_value: bool):
			value = _value
	
	class MainMenuAction extends Event:
		enum Action { SANDBOX, ENDLESS, EXIT, SETTINGS }
		var action: Action
		func _init(_action: Action): 
			action = _action
	
	class PauseMenuAction extends Event:
		enum Action { RESUME, RESTART, SETTINGS, EXIT, QUIT }
		var action: Action
		func _init(_action: Action): 
			action = _action
	
	class EndlessHubMenuAction extends Event:
		enum Action { CLOSE, EXIT, QUIT }
		var action: Action
		func _init(_action: Action): 
			action = _action
	
	class EndlessInventoryMenuAction extends Event:
		enum Action { CLOSE }
		var action: Action
		func _init(_action: Action):
			action = _action

# ===
# Logic
# ===

func publish(event: Event) -> void:
	raised.emit(event)

func subscribe(callback: Callable) -> void:
	if raised.is_connected(callback): return
	raised.connect(callback)

func unsubscribe(callback: Callable) -> void:
	if not raised.is_connected(callback): return
	raised.disconnect(callback)
