class_name DroppedLootDetector
extends Detector

@onready var collision_shape: CollisionShape3D = get_child(0)

# ===
# Public
# ===

func set_cylinder(radius: float, height: float = 2.0):
	var shape = CylinderShape3D.new()
	shape.radius = radius
	shape.height = height
	collision_shape.shape = shape

func set_box(size: Vector3):
	var shape = BoxShape3D.new()
	shape.size = size
	collision_shape.shape = shape

func set_sphere(radius: float):
	var shape = SphereShape3D.new()
	shape.radius = radius
	collision_shape.shape = shape

# ===
# Private
# ===

func _should_detect(sensor: Sensor) -> bool:
	return sensor is DroppedLootSensor
