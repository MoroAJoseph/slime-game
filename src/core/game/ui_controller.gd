class_name UIController
extends Node

enum HUDType { 
	EXPEDITION, 
	HUB, 
	SANDBOX
}
enum MenuType { 
	MAIN, 
	INVENTORY, 
	DISMANTLER, 
	BUILDER_BENCH,
	PROVISIONER,
	PAUSE, 
}

# Layers
@onready var HUD_LAYER: CanvasLayer = $HUD
@onready var MENUS_LAYER: CanvasLayer = $Menus
@onready var LOADING_LAYER: CanvasLayer = $Loading

# HUDs
@onready var HUB_HUD: Control = %HubHUD
@onready var EXPEDITION_HUD: Control = %ExpeditionHUD

# Menus
@onready var MAIN_MENU: Control = %MainMenu
@onready var INVENTORY_MENU: Control = %InventoryMenu
@onready var PAUSE_MENU: Control = %PauseMenu
@onready var DISMANTLER_MENU: Control = %DismantlerMenu
@onready var BUILDER_BENCH_MENU: Control = %BuilderBenchMenu
@onready var PROVISIONER_MENU: Control = %ProvisionerMenu

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

# --- HUD ---
func has_open_huds() -> bool:
	return EXPEDITION_HUD.visible or HUB_HUD.visible

func toggle_hud(type: HUDType, is_visible: bool) -> void:
	var control = _get_hud_control(type)
	if control:
		_toggle_hud_logic(control, is_visible)

# --- Menu ---
func has_open_menus() -> bool:
	return _get_all_menus().any(
		func(menu: Control): 
			return menu.visible
	)

func is_menu_open(type: MenuType) -> bool:
	return _get_menu_control(type).visible

func toggle_menu(type: MenuType, is_visible: bool) -> void:
	var control = _get_menu_control(type)
	if control:
		_toggle_menu_logic(control, is_visible)

func close_all_menus() -> void:
	_hide_all_menus()

# --- Loading ---
func toggle_loading(is_visible: bool) -> void:
	LOADING_LAYER.visible = is_visible

# ===
# Private
# ===

# --- HUD ---
func _toggle_hud_logic(hud: Control, is_visible: bool) -> void:
	hud.visible = is_visible
	HUD_LAYER.visible = has_open_huds()

func _get_hud_control(type: HUDType) -> Control:
	match type:
		HUDType.EXPEDITION: return EXPEDITION_HUD
		HUDType.HUB: return HUB_HUD
	return null

func _hide_all_huds() -> void:
	EXPEDITION_HUD.hide()
	HUB_HUD.hide()
	HUD_LAYER.hide()

# --- Menu ---
func _toggle_menu_logic(menu: Control, is_visible: bool) -> void:
	menu.visible = is_visible
	MENUS_LAYER.visible = has_open_menus()

func _get_menu_control(type: MenuType) -> Control:
	match type:
		# Title
		MenuType.MAIN: return MAIN_MENU
		# Playing
		MenuType.INVENTORY: return INVENTORY_MENU
		MenuType.PAUSE: return PAUSE_MENU
		# Hub
		MenuType.DISMANTLER: return DISMANTLER_MENU
		MenuType.BUILDER_BENCH: return BUILDER_BENCH_MENU
		MenuType.PROVISIONER: return PROVISIONER_MENU
	return null

func _get_all_menus() -> Array[Control]:
	return [
		# Title
		MAIN_MENU, 
		# Playing
		INVENTORY_MENU, 
		PAUSE_MENU, 
		DISMANTLER_MENU,
		BUILDER_BENCH_MENU,
		PROVISIONER_MENU,
	]

func _hide_all_menus() -> void:
	for menu in _get_all_menus():
		menu.hide()
	MENUS_LAYER.hide()
