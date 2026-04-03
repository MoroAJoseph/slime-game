extends GameState

var _enter_data: LoadStateData

# ===
# Parent
# ===

func enter(_prev_state_path: String, data: Object) -> void:
	_enter_data = data as LoadStateData
	if not _enter_data:
		return
	
	EventBus.subscribe(_on_event)
	
	match _enter_data.target_state:
		StateName.TITLE:
			EventBus.publish(EventBus.GameplayEvent.RequestLoadTitle.new())
		StateName.PLAY:
			if _enter_data.level_path == "": 
				push_error("No level path")
				return
			EventBus.publish(EventBus.GameplayEvent.RequestLoadLevel.new(_enter_data.level_path))

func exit() -> void:
	EventBus.unsubscribe(_on_event)

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.GameplayEvent.TitleLoaded:
		_transition_to(_enter_data.target_state, null)
	elif event is EventBus.GameplayEvent.LevelLoaded:
		_transition_to(_enter_data.target_state, null)
