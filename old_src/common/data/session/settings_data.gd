class_name SettingsData
extends Resource

# Audio
@export_range(0.0, 1.0) var master_volume: float
@export var is_master_muted: bool
@export_range(0.0, 1.0) var music_volume: float
@export var is_music_muted: bool
@export_range(0.0, 1.0) var sfx_volume: float
@export var is_sfx_muted: bool

# Visual
@export_range(30, 240) var fps_cap: int
@export var is_fps_uncapped: bool

# Input
@export var mouse_sensitivity: Vector2 # horizontal, vertical
