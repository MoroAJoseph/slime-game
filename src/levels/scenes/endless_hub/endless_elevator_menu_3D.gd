# ElevatorMenu3D.gd
extends StaticBody3D

signal floor_selected(index: int)

@onready var viewport: SubViewport = $SubViewport
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var ui_menu = $SubViewport/EndlessElevatorMenu 

func _ready():
	if ui_menu:
		ui_menu.floor_selected.connect(func(idx): floor_selected.emit(idx))

func handle_mouse_event(hit_position: Vector3):
	# 1. Get the local position relative to the MESH, not the StaticBody
	var local_pos = mesh_instance.to_local(hit_position)
	
	# 2. Normalize to 0.0 - 1.0 (UV Space)
	# If your crosshair is high but the click is low, 
	# we need to adjust the 0.5 offset.
	var uv_x = local_pos.x + 0.5
	var uv_y = 0.5 - local_pos.y # Invert Y: 0.5 is Top, -0.5 is Bottom
	
	# 3. Apply a small "Aim Offset" if the camera is tilted
	# If the click is landing ABOVE the reticle, subtract from uv_y
	# If the click is landing BELOW the reticle, add to uv_y
	# uv_y += 0.05 # Optional: Calibration nudge
	
	var viewport_pos = Vector2(uv_x, uv_y) * Vector2(viewport.size)
	_simulate_click(viewport_pos)

func _simulate_click(pos: Vector2):
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.position = pos
	event.global_position = pos # In a SubViewport, global is relative to the viewport top-left
	
	# 1. MOUSE DOWN
	event.pressed = true
	event.button_mask = MOUSE_BUTTON_MASK_LEFT
	viewport.push_input(event)
	
	# 2. UI UPDATE
	# Force the viewport to process the input immediately
	viewport.handle_input_locally = true 
	
	# 3. MOUSE UP
	await get_tree().process_frame
	event.pressed = false
	event.button_mask = 0
	viewport.push_input(event)
