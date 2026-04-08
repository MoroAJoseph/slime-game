class_name DamageDetector
extends Detector

# ===
# Public
# ===

# ===
# Private
# ===

func _should_detect(sensor: Sensor) -> bool:
	return sensor is DamageSensor
