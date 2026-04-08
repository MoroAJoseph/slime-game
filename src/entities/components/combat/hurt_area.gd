class_name HurtArea
extends Area3D

signal received(data: DamageData)

# ===
# Public
# ===

func receive(data: DamageData) -> void:
	received.emit(data)
