class_name Sensor
extends Area3D

signal entered(identifier: Identifier)
signal exited(identifier: Identifier)

@export var _blacklist: Array[Identifier] = []

var _overlapping_sensors: Array[Identifier] = []

# ===
# Built-In
# ===

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

# ===
# Public
# ===

func add_to_blacklist(identifier: Identifier) -> void:
	_blacklist.append(identifier)

func get_overlapping_sensors() -> Array[Identifier]:
	return _overlapping_sensors

# ===
# Private
# ===

func _should_detect(_identifier: Identifier) -> bool:
	return true

# ===
# Signals
# ===

func _on_area_entered(area: Area3D) -> void:
	if area is Identifier and area.is_active:
		if area in _blacklist or not area.is_active:
			return
		if _should_detect(area):
			_overlapping_sensors.append(area)
			entered.emit(area)

func _on_area_exited(area: Area3D) -> void:
	if area in _overlapping_sensors:
		_overlapping_sensors.erase(area)
		exited.emit(area)
