# Load
extends GameState

var _enter_data: LoadStateData

# ===
# Public
# ===

func enter(_prev_state_path: String, data: Object) -> void:
	_enter_data = data as LoadStateData
	if not _enter_data:
		return
	
	EventBus.subscribe(_on_event)
	_owner._ui_controller.toggle_loading(true)
	
	if _enter_data.target_state == StateName.TITLE:
		_owner._world_controller.load_scene(Constants.LEVEL_TITLE_SCENE_PATH)
	else:
		_owner._world_controller.load_scene(_enter_data.level_path)
	
	

func exit() -> void:
	_owner._ui_controller.toggle_loading(false)
	EventBus.unsubscribe(_on_event)

# ===
# Events
# ===

func _on_event(event: Event) -> void:
	# Level Ready
	if event is WorldEvent.LevelReady:
		if _enter_data.target_state == StateName.HUB:
			Session.save_data()
		_transition_to(_enter_data.target_state, null)
