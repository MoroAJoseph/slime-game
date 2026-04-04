@tool
class_name GunModelController
extends Node3D

@onready var mesh_visual_scene: PackedScene = preload("res://core/mesh/mesh_visual.tscn")

var gun_data: GunData
var _instantiated_parts: Dictionary = {}

# Specific markers for bullet spawning
var _barrel_spawn_marker: Marker3D
var _muzzle_spawn_marker: Marker3D

func rebuild(data: GunData) -> void:
	gun_data = data
	_clear_all()
	_instantiated_parts.clear()
	
	# Reset specific markers
	_barrel_spawn_marker = null
	_muzzle_spawn_marker = null
	
	if not gun_data: return
	
	var frame = gun_data.get_part(GunResource.GunPartSocket.FRAME)
	if frame:
		_assemble_recursive(frame, self, null, GunResource.GunPartSocket.FRAME)

func _assemble_recursive(part_data: GunPartData, parent_node: Node, transform_offset_data: TransformData, socket_type: GunResource.GunPartSocket) -> void:
	if not part_data or not part_data.visual_data: return
	
	if mesh_visual_scene == null:
		mesh_visual_scene = load("res://core/mesh/mesh_visual.tscn")
	
	if not mesh_visual_scene:
		push_error("GunModelController: mesh_visual_scene could not be loaded!")
		return
	
	var instance = mesh_visual_scene.instantiate()
	parent_node.add_child(instance)
	
	if Engine.is_editor_hint():
		instance.owner = get_tree().edited_scene_root

	_instantiated_parts[socket_type] = instance
	
	if instance.has_method("setup_visual"):
		if not part_data.visual_data.mesh_path.is_empty():
			var m = load(part_data.visual_data.mesh_path)
			instance.setup_visual(
				m, 
				part_data.visual_data.color_red, 
				part_data.visual_data.color_green, 
				part_data.visual_data.color_blue
			)
	
	if transform_offset_data:
		instance.position = transform_offset_data.position
		instance.rotation_degrees = transform_offset_data.rotation
		instance.scale = transform_offset_data.scale

	# Handle child sockets
	for socket_key in part_data.visual_data.socket_transforms.keys():
		var t_data = part_data.visual_data.socket_transforms[socket_key]
		
		# SOCKET LOGIC: Bullet Spawns
		if socket_key == GunResource.GunPartSocket.BULLET_SPAWN:
			# Check the current context (is this a Barrel or a Muzzle we are currently building?)
			var marker = _create_bullet_marker(instance, t_data)
			
			if socket_type == GunResource.GunPartSocket.MUZZLE:
				_muzzle_spawn_marker = marker
			elif socket_type == GunResource.GunPartSocket.BARREL:
				_barrel_spawn_marker = marker
			continue
		
		# SOCKET LOGIC: Recursive parts
		var child_part = gun_data.get_part(socket_key)
		if child_part:
			_assemble_recursive(child_part, instance, t_data, socket_key)

## Helper to create the node and set the owner
func _create_bullet_marker(parent: Node, t_data: TransformData) -> Marker3D:
	var marker = Marker3D.new()
	marker.name = "BulletSpawnMarker"
	parent.add_child(marker)
	
	if Engine.is_editor_hint():
		marker.owner = get_tree().edited_scene_root
	
	marker.position = t_data.position
	marker.rotation_degrees = t_data.rotation
	return marker

## Get logic based on muzzle-priority hierarchy
func get_projectile_spawn() -> Transform3D:
	# 1. Prefer Muzzle
	if _muzzle_spawn_marker and is_instance_valid(_muzzle_spawn_marker):
		return _muzzle_spawn_marker.global_transform
	
	# 2. Fallback to Barrel
	if _barrel_spawn_marker and is_instance_valid(_barrel_spawn_marker):
		return _barrel_spawn_marker.global_transform
	
	# 3. Fail state
	push_warning("GunModelController: No bullet spawn marker found on Muzzle or Barrel!")
	return global_transform # Returning global_transform instead of null to prevent physics crashes

func _clear_all() -> void:
	for child in get_children():
		child.free()
