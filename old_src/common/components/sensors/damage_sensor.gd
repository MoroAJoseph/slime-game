class_name DamageSensor
extends Sensor

signal received(data: DamageData)

func receive(data: DamageData) -> void:
	if is_active:
		received.emit(data)
