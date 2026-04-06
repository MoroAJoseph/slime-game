class_name UIController
extends Node

enum HUDType { ENDLESS_EXPEDITION, ENDLESS_HUB }
enum MenuType { MAIN, PAUSE, ENDLESS_HUB, ENDLESS_INVENTORY_MENU }

# Layers
@onready var HUD_LAYER: CanvasLayer = $HUD
@onready var MENUS_LAYER: CanvasLayer = $Menus
@onready var LOADING_LAYER: CanvasLayer = $Loading

# HUDs
@onready var ENDLESS_EXPEDITION_HUD: Control = %EndlessExpeditionHUD
@onready var ENDLESS_HUB_HUD: Control = %EndlessHubHUD

# Menus
@onready var MAIN_MENU: Control = %MainMenu
@onready var PAUSE_MENU: Control = %PauseMenu
@onready var ENDLESS_HUB_MENU: Control = %EndlessHubMenu
@onready var ENDLESS_INVENTORY_MENU: Control = %EndlessInventoryMenu

# ===
# Built-In
# ===

func _ready() -> void:
	hide_all()

# ===
# Public
# ===

func hide_all() -> void:
	HUD_LAYER.hide()
	MENUS_LAYER.hide()
	LOADING_LAYER.hide()
	_hide_all_huds()
	_hide_all_menus()

# HUD
func has_open_huds() -> bool:
	return ENDLESS_EXPEDITION_HUD.visible or ENDLESS_HUB_HUD.visible

func is_hud_open(hud_type: HUDType) -> bool:
	match hud_type:
		HUDType.ENDLESS_EXPEDITION: return ENDLESS_EXPEDITION_HUD.visible
		HUDType.ENDLESS_HUB: return ENDLESS_HUB_HUD.visible
	return false

# Menu
func has_open_menus() -> bool:
	return PAUSE_MENU.visible or ENDLESS_HUB_MENU.visible or ENDLESS_INVENTORY_MENU.visible

func is_menu_open(menu_type: MenuType) -> bool:
	match menu_type:
		MenuType.ENDLESS_INVENTORY_MENU: return ENDLESS_INVENTORY_MENU.visible
		MenuType.ENDLESS_HUB: return ENDLESS_HUB_MENU.visible
		MenuType.PAUSE: return PAUSE_MENU.visible
	return false

# --- Transition Methods ---

func toggle_loading(is_visible: bool) -> void:
	LOADING_LAYER.visible = is_visible

# HUD
func toggle_hud(is_visible: bool) -> void:
	HUD_LAYER.visible = is_visible

func toggle_endless_expedition_hud(is_visible: bool) -> void:
	_toggle_hud_logic(ENDLESS_EXPEDITION_HUD, is_visible)

func toggle_endless_hub_hud(is_visible: bool) -> void:
	_toggle_hud_logic(ENDLESS_HUB_HUD, is_visible)

# Menu
func toggle_main_menu(is_visible: bool) -> void:
	_toggle_menu_logic(MAIN_MENU, is_visible)

func toggle_pause_menu(is_visible: bool) -> void:
	_toggle_menu_logic(PAUSE_MENU, is_visible)

func toggle_endless_hub_menu(is_visible: bool) -> void:
	_toggle_menu_logic(ENDLESS_HUB_MENU, is_visible)

func toggle_endless_inventory_menu(is_visible: bool) -> void:
	_toggle_menu_logic(ENDLESS_INVENTORY_MENU, is_visible)

func close_all_menus() -> void:
	_hide_all_menus()
	MENUS_LAYER.hide()

func toggle_menu(menu_type: MenuType, is_visible: bool) -> void:
	var menu = _get_menu_control(menu_type)
	_toggle_menu_logic(menu, is_visible)

# ===
# Private
# ===

# HUD
func _hide_all_huds() -> void:
	ENDLESS_EXPEDITION_HUD.hide()
	ENDLESS_HUB_HUD.hide()

func _toggle_hud_logic(hud: Control, is_visible: bool) -> void:
	if is_visible:
		HUD_LAYER.show()
		hud.show()
	else:
		hud.hide()

# Menu
func _get_menu_control(type: MenuType) -> Control:
	match type:
		MenuType.MAIN: return MAIN_MENU
		MenuType.PAUSE: return PAUSE_MENU
		MenuType.ENDLESS_HUB: return ENDLESS_HUB_MENU
		MenuType.ENDLESS_INVENTORY_MENU: return ENDLESS_INVENTORY_MENU
	return null

func _hide_all_menus() -> void:
	MAIN_MENU.hide()
	PAUSE_MENU.hide()
	ENDLESS_HUB_MENU.hide()
	ENDLESS_INVENTORY_MENU.hide()

func _toggle_menu_logic(menu: Control, is_visible: bool) -> void:
	if is_visible:
		MENUS_LAYER.show()
		menu.show()
	else:
		menu.hide()
		if not has_open_menus():
			MENUS_LAYER.hide()
