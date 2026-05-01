extends Node

enum GameMode { NONE, STORY, ENDLESS, SANDBOX }

# Persistent Resources
var build_data: BuildData
var user_data: UserData
var settings_data: SettingsData
var last_save_time: float
var current_mode: GameMode = GameMode.NONE

# File Paths
const SAVE_DIR = "user://saves/"
const BUILD_PATH = "user://saves/build.tres"
const SETTINGS_PATH = "user://saves/settings.tres"
const USER_PATH = "user://saves/user.tres"

# ===
# Built-In
# ===

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)
	
	_init_build_data()
	load_data()
	
# ===
# Public
# ===

func save_data() -> void:
	var err_build = ResourceSaver.save(build_data, BUILD_PATH)
	var err_settings = ResourceSaver.save(settings_data, SETTINGS_PATH)
	var err_user = ResourceSaver.save(user_data, USER_PATH)
	
	if (
		err_build == Error.OK and 
		err_settings == Error.OK and 
		err_user == Error.OK
	):
		last_save_time = Time.get_unix_time_from_system()
	else:
		push_error("Session: Failed to save one or more data modules.")

func load_data() -> void:
	settings_data = _safe_load(SETTINGS_PATH, SettingsData.new())
	user_data = _safe_load(USER_PATH, UserData.new())
	save_data()

# ===
# Private
# ===

func _init_build_data() -> void:
	build_data = BuildData.new()
	if not build_data.is_dummy:
		build_data.type = BuildData.Type.DEVELOPMENT
		build_data.date = Time.get_unix_time_from_system()

func _safe_load(path: String, default: Resource) -> Resource:
	if ResourceLoader.exists(path):
		var loaded_res = ResourceLoader.load(path)
		if loaded_res:
			return loaded_res
	return default
