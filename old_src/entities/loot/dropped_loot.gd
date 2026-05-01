class_name DroppedLoot
extends Node3D

@export var inventory_data: InventoryData
@export var is_grounded: bool = true
@export var absorb_radius: float = 2.0 # Increased default for better detection
@export var absorb_threshold: float = 0.2

@onready var INTERACTABLE_SENSOR: InteractableSensor = $InteractableSensor
@onready var GAZE_SENSOR: GazeSensor = $GazeSensor
@onready var DROPPED_LOOT_DETECTOR: DroppedLootDetector = $DroppedLootDetector
@onready var VFX_SOCKET: Node3D = $VFX

var _current_vfx: VFXDroppedLoot
var _greatest_rarity: ItemData.Rarity
var _is_being_absorbed: bool = false
var _absorb_target: Node3D = null

# ===
# Built-In
# ===

func _ready() -> void:
	GAZE_SENSOR.hovered.connect(_on_hover)
	GAZE_SENSOR.unhovered.connect(_on_unhover)
	
	INTERACTABLE_SENSOR.received.connect(_on_interactable_sensor_received)
	
	DROPPED_LOOT_DETECTOR.entered.connect(_on_dropped_loot_entered)
	DROPPED_LOOT_DETECTOR.exited.connect(_on_dropped_loot_exited)
	
	DROPPED_LOOT_DETECTOR.set_cylinder(absorb_radius)
	
	_update_greatest_rarity()
	_update_vfx()

func _physics_process(delta: float) -> void:
	if _is_being_absorbed or not _absorb_target: 
		return
	
	if not is_instance_valid(_absorb_target):
		_absorb_target = null
		return
	
	var target_pos = _absorb_target.global_position
	var current_pos = global_position
	var dist = current_pos.distance_to(target_pos)
	
	# Movement logic
	var base_speed = 5.0 
	var acceleration = clamp(5.0 / (dist + 0.05), 1.0, 20.0)
	var move_dir = current_pos.direction_to(target_pos)
	
	global_position += move_dir * base_speed * acceleration * delta
	
	if dist < absorb_threshold:
		be_absorbed_by(_absorb_target)

# ===
# Public
# ===

func get_rarity() -> ItemData.Rarity:
	return _greatest_rarity

func get_being_absorbed() -> bool:
	return _is_being_absorbed

func get_absorb_target() -> Node3D:
	return _absorb_target

func start_absorb(target: Node3D) -> void:
	# If already shrinking or already moving, don't restart
	if _is_being_absorbed or _absorb_target != null: 
		return
		
	print(name, " STARTING ABSORB towards ", target.name)
	_absorb_target = target

func stop_absorb() -> void:
	_absorb_target = null

func remove_from_inventory(data: InventoryData) -> void:
	for item in data.items:
		inventory_data.remove_item(item)
	_on_inventory_updated()

func add_to_inventory(data: InventoryData) -> void:
	if not data or not data.items: return
	
	for item in data.items:
		inventory_data.add_item(item)
	
	_update_greatest_rarity()
	_on_inventory_updated()

func be_absorbed_by(sink: Node3D) -> void:
	if _is_being_absorbed: return
	_is_being_absorbed = true
	
	# Disable interaction
	INTERACTABLE_SENSOR.is_active = false
	GAZE_SENSOR.is_interactable = false
	_absorb_target = null
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position", sink.global_position, 0.2)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.2)
	
	await tween.finished
	
	if sink.has_method("add_to_inventory"):
		sink.add_to_inventory(self.inventory_data)
	
	queue_free()

# ===
# Private
# ===

func _update_greatest_rarity() -> void:
	var greatest = ItemData.Rarity.COMMON
	if inventory_data and inventory_data.items:
		for item in inventory_data.items:
			if item.rarity > greatest:
				greatest = item.rarity
	
	_greatest_rarity = greatest

func _get_vfx_path() -> String:
	var rarity: int = _greatest_rarity
	var state: String = "ground" if is_grounded else "floating"
	return "res://fx/visual/loot/scenes/{0}_{1}.tscn".format([rarity, state])

func _apply_inventory_scaling() -> void:
	if not _current_vfx or not inventory_data: return
	
	var item_count = inventory_data.items.size()
	# remap(value, istart, istop, ostart, ostop)
	var target_scale_value = remap(item_count, 1, 20, 0.8, 2.5)
	target_scale_value = clamp(target_scale_value, 0.8, 2.5)
	
	var tween = create_tween()
	# We scale the VFX_SOCKET instead of 'self' or the root
	tween.tween_property(VFX_SOCKET, "scale", Vector3.ONE * target_scale_value, 0.3)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _update_vfx() -> void:
	if _current_vfx:
		_current_vfx.queue_free()
	
	var path = _get_vfx_path()
	if not ResourceLoader.exists(path): return
	
	var vfx_scene = load(path)
	if vfx_scene:
		_current_vfx = vfx_scene.instantiate()
		VFX_SOCKET.add_child(_current_vfx)
		_apply_inventory_scaling()

# ===
# Signals
# ===

func _on_hover() -> void:
	pass

func _on_unhover() -> void:
	pass

func _on_interactable_sensor_received(_data: InteractionData) -> void:
	pass

func _on_inventory_updated() -> void:
	_update_vfx()

func _on_dropped_loot_entered(sensor: Sensor) -> void:
	var other_loot = sensor.get_parent()
	
	# 1. Safety check: don't interact with self or null
	if not other_loot or other_loot == self: return
	
	# 2. Duck-typing check: Does the other node have our required methods?
	if not other_loot.has_method("start_absorb") or not other_loot.has_method("get_rarity"):
		return
	
	# 3. Check absorption states
	if _is_being_absorbed or other_loot.get_being_absorbed(): return
	
	var my_rarity = get_rarity()
	var their_rarity = other_loot.get_rarity()
	
	# Logic: If I am "stronger", I pull them.
	if my_rarity > their_rarity or (my_rarity == their_rarity and get_instance_id() > other_loot.get_instance_id()):
		print(name, " is pulling ", other_loot.name)
		other_loot.start_absorb(self)

func _on_dropped_loot_exited(sensor: Sensor) -> void:
	var other_loot = sensor.get_parent()
	if not other_loot: return
	
	if other_loot.has_method("get_absorb_target"):
		if other_loot.get_absorb_target() == self:
			other_loot.stop_absorb()
