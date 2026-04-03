extends Node

signal raised(event: Event)

# ===
# Events
# ===

class Event extends RefCounted: pass
class BootsplashFinished extends Event: pass

# --- Gameplay ---
class GameplayEvent:
	# Actions
	class RequestPause extends Event: pass
	class RequestResume extends Event: pass
	class RequestLoadTitle extends Event: pass
	class RequestLoadLevel extends Event:
		var path: String
		func _init(_path: String): 
			path = _path
	
	# Notifications
	class GamePaused extends Event: pass
	class GameResumed extends Event: pass
	class TitleLoaded extends Event: pass
	class LevelLoaded extends Event:
		var data: LevelData
		func _init(_data: LevelData): 
			data = _data

# --- Player ---
class PlayerEvent:
	# Actions
	class RequestReload extends Event: pass
	
	# Notifications
	class Died extends Event: pass
	class Spawned extends Event: 
		var player: Player
		func _init(_player: Player):
			player = _player
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

# --- UI ---
class UIEvent:
	# Actions
	class ToggleMenu extends Event:
		enum Menu { MAIN, PAUSE }
		var menu: Menu
		var is_visible: bool
		func _init(_menu: Menu, _is_visible: bool):
			menu = _menu
			is_visible = _is_visible
	class ToggleHud extends Event:
		var is_visible: bool
		func _init(_is_visible: bool):
			is_visible = _is_visible
	class ToggleLoading extends Event:
		var is_visible: bool
		func _init(_is_visible: bool): 
			is_visible = _is_visible
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
