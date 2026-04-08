class_name InteractorArea
extends Area3D

signal sent(data: InteractionData)
signal overlaps_updated(data: Array[InteractableArea])

var _overlapping_targets: Array[InteractableArea] = []

# ===
# Built-In
# ===

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

# ===
# Public
# ===

func interact() -> void:
	var target = get_best_target()
	if not target: 
		return
	
	var data = InteractionData.new(owner, target.owner)
	target.receive(data)
	sent.emit(data)

func get_best_target() -> InteractableArea:
	if _overlapping_targets.is_empty(): return null
	
	# Only sort if there's more than one item
	if _overlapping_targets.size() > 1:
		_overlapping_targets.sort_custom(func(a, b):
			return global_position.distance_squared_to(a.global_position) < global_position.distance_squared_to(b.global_position)
		)
	
	return _overlapping_targets[0]

# ===
# Signals
# ===

func _on_area_entered(area: Area3D) -> void:
	if area is InteractableArea:
		_overlapping_targets.append(area)
		overlaps_updated.emit(_overlapping_targets)

func _on_area_exited(area: Area3D) -> void:
	if area is InteractableArea:
		_overlapping_targets.erase(area)
		overlaps_updated.emit(_overlapping_targets)
		
