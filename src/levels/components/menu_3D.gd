class_name Menu3D
extends StaticBody3D

@onready var viewport: SubViewport = $SubViewport
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var _ui_menu: Control 

# ===
# Built-In
# ===

func _ready() -> void:
	_ui_menu = viewport.get_child(0)
	_setup()

# ===
# Public
# ===

func handle_mouse_event(hit_position: Vector3):
	var local_pos = mesh_instance.to_local(hit_position)
	
	var uv_x = local_pos.x + 0.5
	var uv_y = 0.5 - local_pos.y
	
	var viewport_pos = Vector2(uv_x, uv_y) * Vector2(viewport.size)
	_simulate_click(viewport_pos)

# ===
# Private
# ===

func _setup() -> void:
	pass

func _simulate_click(pos: Vector2):
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.position = pos
	event.global_position = pos
	
	event.pressed = true
	event.button_mask = MOUSE_BUTTON_MASK_LEFT
	viewport.push_input(event)
	
	viewport.handle_input_locally = true 
	
	await get_tree().process_frame
	event.pressed = false
	event.button_mask = 0
	viewport.push_input(event)
