class_name InteractableArea
extends Area3D

signal received(data: InteractionData)

# ===
# Public
# ===

func receive(data: InteractionData) -> void:
	received.emit(data)
