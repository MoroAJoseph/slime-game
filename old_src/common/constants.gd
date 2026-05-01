class_name Constants
extends RefCounted

# ===
# Scenes
# ===

# --- Core ---
const BOOTSPLASH_SCENE_PATH: String = "res://core/bootsplash/bootsplash.tscn"
const GAME_SCENE_PATH: String = "res://core/game/game.tscn"
const MESH_VISUAL_SCENE_PATH: String = "res://core/mesh/mesh_visual.tscn"

# --- Levels ---
const LEVEL_TITLE_SCENE_PATH: String = "res://levels/title/title.tscn"
const LEVEL_SANDBOX_SCENE_PATH: String = "res://levels/sandbox/sandbox.tscn"
const LEVEL_HUB_SCENE_PATH: String = "res://levels/hub/hub.tscn"
const LEVEL_WORLD_SCENE_PATH: String = "res://levels/world/world.tscn"

# --- Entities ---
const ENTITY_PLAYER_SCENE_PATH: String = "res://entities/player/player.tscn"
const ENTITY_SLIME_SCENE_PATH: String = "res://entities/slimes/slime.tscn"
const ENTITY_BULLET_SCENE_PATH: String = "res://entities/projectiles/bullet/bullet.tscn"
const ENTITY_GUN_SCENE_PATH: String = "res://entities/weapons/gun/gun.tscn"

# --- Utils ---
const WEAPON_MATERIAL_PATH: String = "res://entities/weapons/base/weapon_rgb_material.res"

# ===
# FX
# ===

# --- Visual ---


# --- Sound ---

# ===
# World
# ===

const LAYER_PHYSICS_3D: Dictionary = {
	"World": 1 << 0,
	"Player": 1 << 1,
	"Enemy": 1 << 2,
	"Player_Projectile": 1 << 3,
	"Enemy_Projectile": 1 << 4,
	"Damage": 1 << 5,
	"Interaction": 1 << 6,
	"Drone": 1 << 7,
	"Debris": 1 << 8,
	"Collectable": 1 << 9,
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
