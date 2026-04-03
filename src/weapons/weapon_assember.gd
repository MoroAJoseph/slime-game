@tool
extends Node3D
class_name WeaponAssembler

@export var weapon_data: WeaponData:
	set(value):
		if weapon_data == value: return
		# Disconnect old signal to prevent ghost updates
		if weapon_data and weapon_data.is_connected("changed", build_weapon):
			weapon_data.disconnect("changed", build_weapon)
		
		weapon_data = value
		
		if weapon_data:
			weapon_data.changed.connect(build_weapon)
			build_weapon()

@onready var mesh_visual_scene: PackedScene = preload("res://core/mesh/mesh_visual.tscn")

func _ready() -> void:
	if weapon_data:
		build_weapon()

func build_weapon() -> void:
	# Use a deferred clear or direct free depending on tool mode
	_clear_all()
	
	if not weapon_data: return
	
	# 1. Find the Frame (The Root of any gun)
	var frame_part = weapon_data.get_part(GunPartVisualData.GunPartSocket.FRAME)
	if not frame_part: 
		push_warning("WeaponAssembler: No Frame part found in WeaponData.")
		return

	# 2. Start the recursive build chain
	_assemble_recursive(frame_part, self, null)

## The Core Recursive Logic
func _assemble_recursive(part_data: GunPartVisualData, parent_node: Node, socket_transform: WeaponPartSocketData) -> void:
	if not part_data or part_data.mesh_file_path == "": return

	# 1. Instantiate the Visual Node
	var instance: MeshVisual = mesh_visual_scene.instantiate()
	parent_node.add_child(instance)
	
	# 2. Load the actual Mesh resource from the path
	var mesh_res = load(part_data.mesh_file_path)
	
	# 3. Setup the Visual (Decoupled: only passing raw primitives)
	instance.setup_visual(
		mesh_res, 
		part_data.default_red, 
		part_data.default_green, 
		part_data.default_blue
	)
	
	# 4. Apply Transformation if attached to a socket
	if socket_transform:
		instance.position = socket_transform.position
		instance.rotation_degrees = socket_transform.rotation
		instance.scale = socket_transform.scale
	
	# 5. RECURSION: Look at this part's sockets and spawn children
	# This allows Frame -> Barrel -> Muzzle chain
	for socket_type in part_data.sockets.keys():
		var child_part = weapon_data.get_part(socket_type)
		if child_part:
			var transform_data = part_data.sockets[socket_type]
			_assemble_recursive(child_part, instance, transform_data)

func _clear_all() -> void:
	for child in get_children():
		# Using free() in tool mode to avoid object ghosting in the editor
		child.free()
