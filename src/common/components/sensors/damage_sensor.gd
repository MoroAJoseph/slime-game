class_name DamageSensor
extends Sensor

signal received(data: DamageData)

func receive(data: DamageData) -> void:
	received.emit(data)
