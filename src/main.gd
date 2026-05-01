extends Node

var _game: Game = null

# ===
# Built-In
# ===

func _ready() -> void:
	_setup_game()

# ===
# Private
# ===

func _setup_game() -> void:
	var scene = load(Constants.GAME_SCENE_PATH)
	_game = scene.instantiate() as Game
	add_child(_game)
