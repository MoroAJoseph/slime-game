class_name BuildData
extends Resource

enum BuildType { PRODUCTION, DEVELOPMENT, PLAYTEST }

@export var version: String = "0.0.1"
@export var build_type: BuildType
@export var build_date: float
@export var is_dummy: bool

func _init() -> void:
	is_dummy = OS.has_feature("editor")
	if is_dummy:
		version = "0.0.1"
		build_type = BuildType.DEVELOPMENT
		build_date = Time.get_unix_time_from_system()
