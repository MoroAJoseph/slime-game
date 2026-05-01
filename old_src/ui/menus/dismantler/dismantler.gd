extends Control

@onready var CLOSE_BUTTON: Button = %CloseButton

# Backpack
@onready var BACKPACK_CONTENT: VBoxContainer = %BackpackContent
@onready var WEAPONS_LIST: VBoxContainer = %WeaponsList

# Staging
@onready var STAGED_LIST: VBoxContainer = %StagedList
@onready var DISMANTLE_BUTTON: Button = %DismantleButton
@onready var DISMANTLE_ITEMS_AMOUNT_LABEL: Label = %DismantleItemsAmount
@onready var DISMANTLE_SCRAP_AMOUNT_LABEL: Label = %DismantleScrapAmount
@onready var DISMANTLE_WEIGHT_AMOUNT_LABEL: Label = %DismantleWeightAmount

var _can_dismantle: bool = true
#var _scrap_amount: int = 0
#var _weight_amount: float = 0.0

# ===
# Built-In
# ===

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	CLOSE_BUTTON.pressed.connect(func(): UIEvent.DismantlerMenu.new(UIEvent.DismantlerMenuAction.CLOSE))
	DISMANTLE_BUTTON.pressed.connect(_on_dismantle)

# ===
# Private
# ===


# ===
# Signals
# ===

func _on_visibility_changed() -> void:
	pass

func _on_dismantle() -> void:
	if not _can_dismantle: return
	_can_dismantle = false
	UIEvent.DismantlerMenu.new(UIEvent.DismantlerMenuAction.DISMANTLE)
	_can_dismantle = true
