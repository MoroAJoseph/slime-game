class_name InventoryData
extends Resource

@export var items: Array[ItemData]

func add_item(item: ItemData) -> void:
	items.append(item)

func remove_item(item: ItemData) -> void:
	items.erase(item)
