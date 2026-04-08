class_name Constants
extends RefCounted

# ===
# Scenes
# ===

# --- Levels ---
const LEVEL_TITLE_SCENE_PATH: String = "res://levels/title/title.tscn"
const LEVEL_SANDBOX_SCENE_PATH: String = "res://levels/sandbox/sandbox.tscn"
const LEVEL_ENDLESS_HUB_SCENE_PATH: String = "res://levels/endless_hub/endless_hub.tscn"

# --- Entities ---
const ENTITY_PLAYER_SCENE_PATH: String = "res://entities/player/scenes/player.tscn"

# ===
# World
# ===

const LAYER_PHYSICS_3D: Dictionary = {
	"World": 1 << 0,
	"Player": 1 << 1,
	"Enemy": 1 << 2,
	"Player_Projectile": 1 << 3,
	"Enemy_Projectile": 1 << 4,
	"Hit_Hurt": 1 << 5,
	"Sensor": 1 << 6,
	"Gaze": 1 << 7,
	"Debris": 1 << 8,
}

const LAYER_RENDER_3D: Dictionary = {
	"World": 1 << 0,
	"Player_Third": 1 << 1,
	"Player_First": 1 << 2,
	"Projectile": 1 << 3,
	"Minimap": 1 << 4,
	"Enemy": 1 << 5,
	"Transparent": 1 << 6,
	"UI_3D": 1 << 7,
	"Occlusion": 1 << 8,
	"Outline_Highlight": 1 << 9,
	"FX_Primary": 1 << 10,
	"FX_Secondary": 1 << 11
}

const LAYER_NAVIGATION_3D: Dictionary = {
	
}
