# Load
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
	_ui_controller.toggle_loading(true)
	
	if _enter_data.target_state == StateName.TITLE:
		_world_controller.load_scene(_title_level_path)
	else:
		_world_controller.load_scene(_enter_data.level_path)
	
	# TODO: await the loading screen duration here

func exit() -> void:
	_ui_controller.toggle_loading(false)
	EventBus.unsubscribe(_on_event)

# ===
# Events
# ===

func _on_event(event: EventBus.Event) -> void:
	if event is EventBus.GameplayEvent.TitleLoaded or event is EventBus.GameplayEvent.LevelLoaded:
		if _enter_data.target_state == StateName.HUB:
			Session.save_data()
		_transition_to(_enter_data.target_state, null)
