extends Control

enum LeftTab { WEAPONS, CORES }
enum RightTab { LOADOUT, PREVIEW }

@export var backpack_data: EndlessBackpackData
@export var loadout_data: PlayerLoadoutData
@export var item_slot_scene: PackedScene

@onready var CLOSE_BUTTON: Button = %CloseButton

# Weapons
@onready var WEAPONS_TAB_BUTTON: Button = %WeaponsTab
@onready var WEAPONS_TAB_CONTENT: VBoxContainer = %WeaponsContent
@onready var WEAPONS_LIST: VBoxContainer = %WeaponsList
@onready var CURRENT_WEAPON_ITEMS_COUNT_LABEL: Label = %CurrentWeaponItemsCount
@onready var CURRENT_WEAPONS_WEIGHT_LABEL: Label = %CurrentWeaponsWeight
@onready var MAX_WEAPONS_WEIGHT_LABEL: Label = %MaxWeaponsWeight

# Cores
@onready var CORES_TAB_BUTTON: Button = %CoresTab
@onready var CORES_TAB_CONTENT: VBoxContainer = %CoresContent
@onready var CORES_LIST: VBoxContainer = %CoresList
@onready var CURRENT_CORE_ITEMS_COUNT_LABEL: Label = %CurrentCoreItemsCount

# Loadout
@onready var LOADOUT_TAB_BUTTON: Button = %LoadoutTab
@onready var LOADOUT_TAB_CONTENT: VBoxContainer = %LoadoutContent
@onready var LOADOUT_SWAP_BUTTON: Button = %LoadoutSwapButton

# Preview
@onready var PREVIEW_TAB_BUTTON: Button = %PreviewTab
@onready var PREVIEW_TAB_CONTENT: VBoxContainer = %PreviewContent

var _current_left_tab: LeftTab = LeftTab.WEAPONS:
	set(v):
		if _current_left_tab == v and is_inside_tree(): return 
		_current_left_tab = v
		_refresh_left_ui()

var _current_right_tab: RightTab = RightTab.LOADOUT:
	set(v):
		if _current_right_tab == v and is_inside_tree(): return 
		_current_right_tab = v
		_refresh_right_ui()
# ===
# Built-In
# ===

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	
	CLOSE_BUTTON.pressed.connect(func(): UIEvent.InventoryMenu.new(UIEvent.InventoryMenuAction.CLOSE))
	
	# Left Tabs
	WEAPONS_TAB_BUTTON.pressed.connect(func(): _current_left_tab = LeftTab.WEAPONS)
	CORES_TAB_BUTTON.pressed.connect(func(): _current_left_tab = LeftTab.CORES)
	
	WEAPONS_TAB_BUTTON.button_pressed = true
	
	# Right Tabs
	LOADOUT_TAB_BUTTON.pressed.connect(func(): _current_right_tab = RightTab.LOADOUT)
	PREVIEW_TAB_BUTTON.pressed.connect(func(): _current_right_tab = RightTab.PREVIEW)
	
	LOADOUT_TAB_BUTTON.button_pressed = true

# ===
# Private
# ===

func _refresh_left_ui() -> void:
	if not is_node_ready(): return
	
	_hide_all_left_tabs()
	_update_weight_display()
	
	match _current_left_tab:
		LeftTab.WEAPONS:
			#_populate_list(WEAPONS_LIST, backpack_data.weapons)
			var weapons: Array[WeaponData] = backpack_data.get_weapons()
			CURRENT_WEAPON_ITEMS_COUNT_LABEL.text = str(weapons.size())
			WEAPONS_TAB_CONTENT.show()
		LeftTab.CORES:
			#_populate_list(CORES_LIST, backpack_data.cores)
			CURRENT_CORE_ITEMS_COUNT_LABEL.text = str(backpack_data.cores.size())
			CORES_TAB_CONTENT.show()

func _refresh_right_ui() -> void:
	if not is_node_ready(): return
	
	_hide_all_right_tabs()
	
	match _current_right_tab:
		RightTab.LOADOUT:
			LOADOUT_TAB_CONTENT.show()
		RightTab.PREVIEW:
			PREVIEW_TAB_CONTENT.show()

func _hide_all_left_tabs() -> void:
	WEAPONS_TAB_CONTENT.hide()
	CORES_TAB_CONTENT.hide()

func _hide_all_right_tabs() -> void:
	LOADOUT_TAB_CONTENT.hide()
	PREVIEW_TAB_CONTENT.hide()

func _update_weight_display() -> void:
	var current: float = backpack_data.get_total_weapons_weight()
	var maximum: float = backpack_data.max_weapons_weight
	
	# Update the Weight Labels
	CURRENT_WEAPONS_WEIGHT_LABEL.text = str(current)
	MAX_WEAPONS_WEIGHT_LABEL.text = str(maximum)
	
	# Visual feedback: Turn the current weight red if over capacity
	if current > maximum:
		CURRENT_WEAPONS_WEIGHT_LABEL.add_theme_color_override("font_color", Color.RED)
	else:
		CURRENT_WEAPONS_WEIGHT_LABEL.remove_theme_color_override("font_color")

func _populate_list(container: VBoxContainer, items: Array) -> void:
	# Clear existing immediately to prevent layout flickering
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
		
	# Instantiate new slots
	for item_data in items:
		var slot = item_slot_scene.instantiate()
		container.add_child(slot)
		if slot.has_method("setup"):
			slot.setup(item_data)

# ===
# Public
# ===


# ===
# Signals
# ===

func _on_visibility_changed() -> void:
	if visible:
		# Ensure buttons visually match the internal state when re-opening
		WEAPONS_TAB_BUTTON.set_pressed_no_signal(_current_left_tab == LeftTab.WEAPONS)
		CORES_TAB_BUTTON.set_pressed_no_signal(_current_left_tab == LeftTab.CORES)
		_refresh_left_ui()
		LOADOUT_TAB_BUTTON.set_pressed_no_signal(_current_right_tab == RightTab.LOADOUT)
		PREVIEW_TAB_BUTTON.set_pressed_no_signal(_current_right_tab == RightTab.PREVIEW)
		_refresh_right_ui()
