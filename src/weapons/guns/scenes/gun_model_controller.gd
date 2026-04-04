@tool
class_name GunModelController
extends Node3D

@onready var mesh_visual_scene: PackedScene = preload("res://core/mesh/mesh_visual.tscn")
const WEAPON_MATERIAL_PATH: String = "res://weapons/base/weapon_rgb_material.res"

var gun_data: GunData
var _instantiated_parts: Dictionary = {}

# Specific markers for bullet spawning
var _barrel_spawn_marker: Marker3D
var _muzzle_spawn_marker: Marker3D

func rebuild(data: GunData) -> void:
	gun_data = data
	_clear_all()
	_instantiated_parts.clear()
	
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
	
	var instance = mesh_visual_scene.instantiate() as MeshVisual
	parent_node.add_child(instance)
	
	if Engine.is_editor_hint():
		instance.owner = get_tree().edited_scene_root

	_instantiated_parts[socket_type] = instance
	
	# --- MATERIAL LOGIC ---
	var base_mat = load(WEAPON_MATERIAL_PATH)
	var material_instance: ShaderMaterial = null # Cast to ShaderMaterial
	if base_mat:
		material_instance = base_mat.duplicate()
	
	if instance.has_method("setup_visual"):
		if not part_data.visual_data.mesh_path.is_empty():
			var mesh_res = load(part_data.visual_data.mesh_path)
			instance.setup_visual(
				mesh_res, 
				part_data.visual_data.color_red, 
				part_data.visual_data.color_green, 
				part_data.visual_data.color_blue,
				material_instance
			)
	
	if transform_offset_data:
		instance.position = transform_offset_data.position
		instance.rotation_degrees = transform_offset_data.rotation
		instance.scale = transform_offset_data.scale

	for socket_key in part_data.visual_data.socket_transforms.keys():
		var t_data = part_data.visual_data.socket_transforms[socket_key]
		if socket_key == GunResource.GunPartSocket.BULLET_SPAWN:
			var marker = _create_bullet_marker(instance, t_data)
			if socket_type == GunResource.GunPartSocket.MUZZLE:
				_muzzle_spawn_marker = marker
			elif socket_type == GunResource.GunPartSocket.BARREL:
				_barrel_spawn_marker = marker
			continue
		
		var child_part = gun_data.get_part(socket_key)
		if child_part:
			_assemble_recursive(child_part, instance, t_data, socket_key)

func _create_bullet_marker(parent: Node, t_data: TransformData) -> Marker3D:
	var marker = Marker3D.new()
	marker.name = "BulletSpawnMarker"
	parent.add_child(marker)
	if Engine.is_editor_hint(): marker.owner = get_tree().edited_scene_root
	marker.position = t_data.position
	marker.rotation_degrees = t_data.rotation
	return marker

func get_projectile_spawn() -> Transform3D:
	if is_instance_valid(_muzzle_spawn_marker): return _muzzle_spawn_marker.global_transform
	if is_instance_valid(_barrel_spawn_marker): return _barrel_spawn_marker.global_transform
	return global_transform

func _clear_all() -> void:
	for child in get_children():
		child.queue_free()
