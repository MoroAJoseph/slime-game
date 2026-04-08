extends Node

signal raised(event: Event)

func subscribe(callback: Callable) -> void:
	if not raised.is_connected(callback):
		raised.connect(callback)

func unsubscribe(callback: Callable) -> void:
	if raised.is_connected(callback):
		raised.disconnect(callback)
