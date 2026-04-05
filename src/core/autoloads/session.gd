extends Node

# Persistent Resources
var build_data: BuildData
var user_data: UserData
var settings_data: SettingsData
var endless_data: EndlessDataPersistent
var last_save_time: float
var last_save_path: String

# File Paths
const SAVE_DIR = "user://saves/"
const ENDLESS_PATH = "user://saves/endless.tres"
const SETTINGS_PATH = "user://saves/settings.tres"
const USER_PATH = "user://saves/user.tres"

# ===
# Built-In
# ===

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)
	
	load_data()
	_init_build_data()
	
# ===
# Public
# ===

func save_data() -> void:
	var err_endless = ResourceSaver.save(endless_data, ENDLESS_PATH)
	var err_settings = ResourceSaver.save(settings_data, SETTINGS_PATH)
	var err_user = ResourceSaver.save(user_data, USER_PATH)
	
	if err_endless == OK and err_settings == OK and err_user == OK:
		last_save_time = Time.get_unix_time_from_system()
		print("Session: Data persistent across all modules.")
	else:
		push_error("Session: Failed to save one or more data modules.")

func load_data() -> void:
	endless_data = _safe_load(ENDLESS_PATH, EndlessDataPersistent.new())
	settings_data = _safe_load(SETTINGS_PATH, SettingsData.new())
	user_data = _safe_load(USER_PATH, UserData.new())
	print("Session: Load complete.")

# ===
# Private
# ===

func _init_build_data() -> void:
	build_data = BuildData.new()
	if not build_data.is_dummy:
		# TODO: get real values from a toml, yaml, or some manifest file.
		build_data.version = ProjectSettings.get_setting("application/config/version")
		build_data.build_type = BuildData.BuildType.DEVELOPMENT
		build_data.build_date = Time.get_unix_time_from_system()

func _safe_load(path: String, default: Resource) -> Resource:
	if ResourceLoader.exists(path):
		var loaded_res = ResourceLoader.load(path)
		if loaded_res:
			return loaded_res
	return default
