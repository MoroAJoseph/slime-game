class_name Constants
extends RefCounted

# ===
# Enums
# ===

enum HUDOption {
	SAFE,
	EXPEDITION
}

enum MenuOption {
	MAIN,
	SETTINGS,
	PAUSE,
	INVENTORY,
}

# ===
# Scenes
# ===

# --- Core ---
const GAME_SCENE_PATH: String = "res://core/game/game.tscn"

# --- Levels ---
const LEVEL_TITLE_SCENE_PATH: String = "res://levels/title/title.tscn"
const LEVEL_HUB_SCENE_PATH: String = "res://levels/hub/hub.tscn"
const LEVEL_WORLD_SCENE_PATH: String = "res://levels/world/world.tscn"

# --- Entities ---
const ENTITY_PLAYER_SCENE_PATH: String = "res://core/player/player.tscn"
