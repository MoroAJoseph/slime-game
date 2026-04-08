class_name UIController
extends Node

enum HUDType { 
	ENDLESS_EXPEDITION, 
	ENDLESS_HUB, 
	SANDBOX
}
enum MenuType { 
	TITLE_MAIN, 
	ENDLESS_INVENTORY, 
	ENDLESS_HUB_MAIN, 
	ENDLESS_HUB_DISMANTLER, 
	ENDLESS_HUB_BUILDER_BENCH,
	ENDLESS_HUB_PROVISIONER,
	ENDLESS_EXPEDIION_PAUSE, 
}

# Layers
@onready var HUD_LAYER: CanvasLayer = $HUD
@onready var MENUS_LAYER: CanvasLayer = $Menus
@onready var LOADING_LAYER: CanvasLayer = $Loading

# HUDs
@onready var ENDLESS_EXPEDITION_HUD: Control = %EndlessExpeditionHUD
@onready var ENDLESS_HUB_HUD: Control = %EndlessHubHUD

# Menus
@onready var TITLE_MAIN_MENU: Control = %TitleMainMenu
@onready var ENDLESS_INVENTORY_MENU: Control = %EndlessInventoryMenu
@onready var ENDLESS_HUB_MAIN_MENU: Control = %EndlessHubMainMenu
@onready var ENDLESS_HUB_DISMANTLER_MENU: Control = %EndlessHubDismantlerMenu
@onready var ENDLESS_HUB_BUILDER_BENCH_MENU: Control = %EndlessHubBuilderBenchMenu
@onready var ENDLESS_HUB_PROVISIONER_MENU: Control = %EndlessHubProvisionerMenu
@onready var ENDLESS_EXPEDITION_PAUSE_MENU: Control = %EndlessExpeditionPauseMenu

# ===
# Built-In
# ===

func _ready() -> void:
	hide_all()

# ===
# Public
# ===

func hide_all() -> void:
	LOADING_LAYER.hide()
	_hide_all_huds()
	_hide_all_menus()

# --- HUD Logic ---

func has_open_huds() -> bool:
	return ENDLESS_EXPEDITION_HUD.visible or ENDLESS_HUB_HUD.visible

func toggle_endless_expedition_hud(is_visible: bool) -> void:
	_toggle_hud_logic(ENDLESS_EXPEDITION_HUD, is_visible)

func toggle_endless_hub_hud(is_visible: bool) -> void:
	_toggle_hud_logic(ENDLESS_HUB_HUD, is_visible)

# --- Menu Logic ---

func has_open_menus() -> bool:
	return _get_all_menus().any(func(m): return m.visible)

func toggle_menu(type: MenuType, is_visible: bool) -> void:
	var menu = _get_menu_control(type)
	if menu:
		_toggle_menu_logic(menu, is_visible)

func close_all_menus() -> void:
	_hide_all_menus()

func toggle_loading(is_visible: bool) -> void:
	LOADING_LAYER.visible = is_visible

# ===
# Private
# ===

func _toggle_hud_logic(hud: Control, is_visible: bool) -> void:
	hud.visible = is_visible
	HUD_LAYER.visible = has_open_huds()

func _toggle_menu_logic(menu: Control, is_visible: bool) -> void:
	menu.visible = is_visible
	MENUS_LAYER.visible = has_open_menus()

func _get_menu_control(type: MenuType) -> Control:
	match type:
		# Title
		MenuType.TITLE_MAIN: return TITLE_MAIN_MENU
		# Endless
		MenuType.ENDLESS_INVENTORY: return ENDLESS_INVENTORY_MENU
		# Endless Hub
		MenuType.ENDLESS_HUB_MAIN: return ENDLESS_HUB_MAIN_MENU
		MenuType.ENDLESS_HUB_DISMANTLER: return ENDLESS_HUB_DISMANTLER_MENU
		MenuType.ENDLESS_HUB_BUILDER_BENCH: return ENDLESS_HUB_BUILDER_BENCH_MENU
		MenuType.ENDLESS_HUB_PROVISIONER: return ENDLESS_HUB_PROVISIONER_MENU
		# Endless Expedition
		MenuType.ENDLESS_EXPEDIION_PAUSE: return ENDLESS_EXPEDITION_PAUSE_MENU
	return null

func _get_all_menus() -> Array[Control]:
	return [
		# Title
		TITLE_MAIN_MENU, 
		# Endless
		ENDLESS_INVENTORY_MENU, 
		# Endless Hub
		ENDLESS_HUB_MAIN_MENU, 
		ENDLESS_HUB_DISMANTLER_MENU,
		ENDLESS_HUB_BUILDER_BENCH_MENU,
		ENDLESS_HUB_PROVISIONER_MENU,
		# Endless Expedition
		ENDLESS_EXPEDITION_PAUSE_MENU, 
	]

func _hide_all_huds() -> void:
	ENDLESS_EXPEDITION_HUD.hide()
	ENDLESS_HUB_HUD.hide()
	HUD_LAYER.hide()

func _hide_all_menus() -> void:
	for menu in _get_all_menus():
		menu.hide()
	MENUS_LAYER.hide()
