@tool
extends Node3D

## Drag a GunData resource here to start building
@export var active_gun_data: GunData:
	set(v):
		if active_gun_data and active_gun_data.changed.is_connected(_refresh_workbench):
			active_gun_data.changed.disconnect(_refresh_workbench)
		
		active_gun_data = v
		
		if active_gun_data:
			if not active_gun_data.changed.is_connected(_refresh_workbench):
				active_gun_data.changed.connect(_refresh_workbench)
		
		_refresh_workbench()

@onready var gun_instance: Gun = $Gun

func _ready() -> void:
	_refresh_workbench()

func _refresh_workbench() -> void:
	if not is_inside_tree(): return
	
	# Fallback if @onready hasn't fired yet in editor
	var gun = gun_instance if gun_instance else get_node_or_null("Gun")
	
	if active_gun_data and gun:
		gun.set_gun_data(active_gun_data)
		print("Workbench: Rebuilt ", active_gun_data.resource_name)
	elif gun:
		var mc = gun.get_node_or_null("GunModelController")
		if mc: mc._clear_all()
