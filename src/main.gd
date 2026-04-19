extends Node

var _bootsplash: Bootsplash = null
var _game: Game = null

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)
	_setup_bootsplash()

# ===
# Private
# ===

func _setup_bootsplash() -> void:
	var scene = load(Constants.BOOTSPLASH_SCENE_PATH)
	_bootsplash = scene.instantiate() as Bootsplash
	add_child(_bootsplash)

func _setup_game() -> void:
	var scene = load(Constants.GAME_SCENE_PATH)
	_game = scene.instantiate() as Game
	add_child(_game)

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	if event is GameEvent.BootsplashFinished:
		if _bootsplash:
			_bootsplash.queue_free()
			_bootsplash = null
		
		_setup_game()
		EventBus.unsubscribe(_on_event)
