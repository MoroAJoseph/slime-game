class_name Hurtbox
extends Area3D

signal hit_received(damage_data: DamageData)

# ===
# Local
# ===

func receive_hit(damage_data: DamageData) -> void:
	hit_received.emit(damage_data)
