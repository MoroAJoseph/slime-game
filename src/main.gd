extends Node

@export var _bootsplash_scene: PackedScene
@export var _game_scene: PackedScene

var _current_bootsplash: Bootsplash = null
var _current_game: Game = null

func _ready() -> void:
	EventBus.subscribe(_on_event)
	_setup_bootsplash()

func _setup_bootsplash() -> void:
	if _bootsplash_scene:
		_current_bootsplash = _bootsplash_scene.instantiate() as Bootsplash
		add_child(_current_bootsplash)

func _on_event(event: Object) -> void:
	# Use pattern matching to find our specific event
	if event is EventBus.BootsplashFinished:
		_on_bootsplash_finished()

func _on_bootsplash_finished() -> void:
	# Cleanup the splash immediately
	if _current_bootsplash:
		_current_bootsplash.queue_free()
		_current_bootsplash = null
	
	# Transition to the main game
	_setup_game()
	
	# Since Main only cares about the bootsplash once, we can unsubscribe here
	EventBus.unsubscribe(_on_event)

func _setup_game() -> void:
	if _game_scene:
		_current_game = _game_scene.instantiate() as Game
		add_child(_current_game)
