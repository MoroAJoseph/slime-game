class_name PlayerDetector
extends Detector

# ===
# Public
# ===

# ===
# Private
# ===

func _should_detect(sensor: Sensor) -> bool:
	return sensor is PlayerSensor
