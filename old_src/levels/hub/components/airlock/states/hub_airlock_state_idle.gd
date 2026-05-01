# Idle
extends HubAirlockState

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	if _prev_state_path == "":
		_owner._animation_player.play("open_door")
	
	_owner._player_detector.entered.connect(_on_player_entered)
	_owner._player_detector.exited.connect(_on_player_exited)
	_owner._menu.activated.connect(_on_activated)

func exit() -> void:
	_owner._player_detector.entered.disconnect(_on_player_entered)
	_owner._player_detector.exited.disconnect(_on_player_exited)
	_owner._menu.activated.disconnect(_on_activated)

# ===
# Signals
# ===

func _on_player_entered(_sensor: PlayerSensor) -> void:
	_owner._menu.show()

func _on_player_exited(_sensor: PlayerSensor) -> void:
	_owner._menu.hide()

func _on_activated() -> void:
	_owner._menu.hide()
	_owner._animation_player.play("close_door")
	print_debug("activated")
