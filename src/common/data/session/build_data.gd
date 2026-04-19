class_name BuildData
extends Resource

enum Type { PRODUCTION, DEVELOPMENT, PLAYTEST }

@export var version: String = "0.0.1"
@export var type: Type
@export var date: float
@export var is_dummy: bool

func _init() -> void:
	is_dummy = OS.has_feature("editor")
	if is_dummy:
		version = ProjectSettings.get_setting("application/config/version")
		type = Type.DEVELOPMENT
		date = Time.get_unix_time_from_system()
