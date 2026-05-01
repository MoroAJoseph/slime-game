class_name PlayerModelController
extends Node3D

@export_group("Spawn")
@export var spawn_meshes: Array[MeshInstance3D] = []
@export var player_spawn_shader: Shader
@export var weapon_spawn_shader: Shader

@export_group("Death")
@export var death_particles: GPUParticles3D 

# Bone Attachments
@onready var _skeleton: Skeleton3D = $Armature/GeneralSkeleton
@onready var _right_hand: BoneAttachment3D = %RightHand
@onready var _right_hip: BoneAttachment3D = %RightHip
@onready var _upper_back: BoneAttachment3D = %UpperBack
@onready var _lower_back: BoneAttachment3D = %LowerBack

var _active_weapon_node: Node3D
var _current_spawn_height: float = -0.5

# ===
# Public
# ===

func update_spawn_visual(height_offset: float) -> void:
	_current_spawn_height = global_position.y + height_offset
	_propagate_spawn_height(self)

func set_spawn_visuals(active: bool) -> void:
	for mesh in spawn_meshes:
		_apply_spawn_material(mesh, active, player_spawn_shader)
	
	var slots = [_right_hand, _right_hip, _upper_back, _lower_back ]
	for slot in slots:
		_recursive_mesh_apply(slot, active, weapon_spawn_shader)

func update_full_loadout(primary: WeaponData, secondary: WeaponData, active_slot: int) -> void:
	_clear_slot(_right_hand)
	_clear_slot(_right_hip)
	_clear_slot(_upper_back)
	_clear_slot(_lower_back)

	if active_slot == 0: # Primary in hand
		equip_weapon(primary)
		update_holster_visual(secondary, _right_hip)
	elif active_slot == 1: # Secondary in hand
		equip_weapon(secondary)
		update_holster_visual(primary, _upper_back)
	else: # Both sheathed
		update_holster_visual(primary, _upper_back)
		update_holster_visual(secondary, _right_hip)

func set_sheathed(primary: WeaponData, secondary: WeaponData, is_sheathed: bool, last_slot: int) -> void:
	if is_sheathed:
		update_full_loadout(primary, secondary, -1)
	else:
		update_full_loadout(primary, secondary, last_slot)

func equip_weapon(weapon_data: WeaponData) -> Node3D:
	_clear_slot(_right_hand)
	
	if not weapon_data:
		_active_weapon_node = null
		return null

	var weapon = _spawn_weapon(weapon_data)
	if weapon:
		_right_hand.add_child(weapon)
		_active_weapon_node = weapon
		_apply_transform(weapon, weapon_data.right_hand_bone_transform)

		if _is_spawn_effect_active():
			_recursive_mesh_apply(weapon, true, weapon_spawn_shader)

	return _active_weapon_node

func update_holster_visual(weapon_data: WeaponData, slot: BoneAttachment3D) -> void:
	_clear_slot(slot)
		
	if weapon_data:
		var holster_instance = _spawn_weapon(weapon_data)
		slot.add_child(holster_instance)
		holster_instance.set_process(false)
		
		# Auto-select the correct transform from WeaponData based on the slot provided
		var target_transform: TransformData = null
		if slot == _right_hip:
			target_transform = weapon_data.right_hip_bone_transform
		elif slot == _upper_back:
			target_transform = weapon_data.upper_back_bone_transform
		elif slot == _lower_back:
			target_transform = weapon_data.lower_back_bone_transform
			
		_apply_transform(holster_instance, target_transform)
		
		if _is_spawn_effect_active():
			_recursive_mesh_apply(holster_instance, true, weapon_spawn_shader)

func reset_visuals() -> void:
	set_spawn_visuals(false)
	_skeleton.visible = true
	if death_particles:
		death_particles.emitting = false

func trigger_death_visuals() -> void:
	_skeleton.visible = false
	if death_particles:
		death_particles.emitting = true

# ===
# Private
# ===

func _clear_slot(slot: Node) -> void:
	for child in slot.get_children():
		slot.remove_child(child)
		child.queue_free()

func _apply_transform(node: Node3D, data: TransformData) -> void:
	if not data: return
	
	node.position = data.position
	node.rotation_degrees = data.rotation
	node.scale = data.scale

func _apply_spawn_material(mesh: MeshInstance3D, active: bool, shader_res: Shader) -> void:
	if active:
		if shader_res == null:
			mesh.material_override = null
			return
			
		var original_mat = mesh.get_active_material(0)
		var new_mat = ShaderMaterial.new()
		
		new_mat.shader = shader_res
		
		if original_mat:
			if original_mat is ShaderMaterial:
				var params = ["red_color", "green_color", "blue_color", "albedo", "texture_albedo"]
				for param in params:
					var val = original_mat.get_shader_parameter(param)
					if val != null: new_mat.set_shader_parameter(param, val)
			elif original_mat is StandardMaterial3D:
				new_mat.set_shader_parameter("albedo", original_mat.albedo_color)
				new_mat.set_shader_parameter("texture_albedo", original_mat.albedo_texture)
		
		new_mat.set_shader_parameter("spawn_height", _current_spawn_height)
		
		mesh.material_override = new_mat
	else:
		mesh.material_override = null

func _recursive_mesh_apply(node: Node, active: bool, shader_res: Shader) -> void:
	if node is MeshInstance3D:
		_apply_spawn_material(node, active, shader_res)
	for child in node.get_children():
		_recursive_mesh_apply(child, active, shader_res)

func _propagate_spawn_height(node: Node) -> void:
	if node is MeshInstance3D and node.material_override is ShaderMaterial:
		node.material_override.set_shader_parameter("spawn_height", _current_spawn_height)
	for child in node.get_children():
		_propagate_spawn_height(child)

func _spawn_weapon(weapon_data: WeaponData) -> Node3D:
	if weapon_data is GunData:
		var gun = load(Constants.ENTITY_GUN_SCENE_PATH).instantiate() as Gun
		gun.set_data(weapon_data)
		return gun
	
	# TODO: Sword

	return null

func _is_spawn_effect_active() -> bool:
	return spawn_meshes.size() > 0 and spawn_meshes[0].material_override != null
