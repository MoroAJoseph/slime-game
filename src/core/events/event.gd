class_name Event
extends RefCounted

enum ResponseResult { SUCCESS, FAIL }

func emit() -> void:
	EventBus.raised.emit(self)

func is_type(type: Event) -> bool:
	return is_instance_of(self, type)
