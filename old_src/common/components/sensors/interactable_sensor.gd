class_name InteractableSensor
extends Sensor

signal received(data: InteractionData)

# ===
# Public
# ===

func receive(data: InteractionData) -> void:
	received.emit(data)
