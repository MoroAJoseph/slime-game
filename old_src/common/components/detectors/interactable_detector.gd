class_name InteractableDetector
extends Detector

signal sent(data: InteractionData)

# ===
# Public
# ===

func interact() -> void:
	var sensor = get_best_target() as InteractableSensor
	if not sensor: return
	
	var data = InteractionData.new(owner, sensor.owner)
	sensor.receive(data)
	sent.emit(data)

func get_best_target() -> InteractableSensor:
	var sensors = get_overlapping_sensors()
	if sensors.is_empty(): return null
	
	if sensors.size() > 1:
		# Using distance_squared_to for performance (no square root)
		sensors.sort_custom(func(a, b):
			return global_position.distance_squared_to(a.global_position) < \
				   global_position.distance_squared_to(b.global_position)
		)
	
	return sensors[0] as InteractableSensor

# ===
# Private
# ===

func _should_detect(sensor: Sensor) -> bool:
	return sensor is InteractableSensor
