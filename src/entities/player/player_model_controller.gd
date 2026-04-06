class_name PlayerModelController
extends Node3D

## Manages the visual representation of the player, including weapon attachments,
## holographic spawn effects, and death transitions.

@export_group("Spawn")
@export var spawn_meshes: Array[MeshInstance3D] = []
@export var player_spawn_shader: Shader
@export var weapon_spawn_shader: Shader

@export_group("Death")
@export var death_particles: GPUParticles3D 

@onready var _gun_scene: PackedScene = preload("res://weapons/guns/scenes/gun.tscn")

# Bone Attachments
@onready var SKELETON: Skeleton3D = $Armature/GeneralSkeleton
@onready var RIGHT_HAND: BoneAttachment3D = $Armature/GeneralSkeleton/RIGHT_HAND
@onready var RIGHT_HIP: BoneAttachment3D = $Armature/GeneralSkeleton/RIGHT_HIP
@onready var UPPER_BACK: BoneAttachment3D = $Armature/GeneralSkeleton/UPPER_BACK
@onready var LOWER_BACK: BoneAttachment3D = $Armature/GeneralSkeleton/LOWER_BACK

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
	
	var slots = [RIGHT_HAND, RIGHT_HIP, UPPER_BACK, LOWER_BACK ]
	for slot in slots:
		_recursive_mesh_apply(slot, active, weapon_spawn_shader)

func update_full_loadout(primary: WeaponData, secondary: WeaponData, active_slot: int) -> void:
	_clear_slot(RIGHT_HAND)
	_clear_slot(RIGHT_HIP)
	_clear_slot(UPPER_BACK)
	_clear_slot(LOWER_BACK)

	if active_slot == 0: # Primary in hand
		equip_weapon(primary)
		update_holster_visual(secondary, RIGHT_HIP)
	elif active_slot == 1: # Secondary in hand
		equip_weapon(secondary)
		update_holster_visual(primary, UPPER_BACK)
	else: # Both sheathed
		update_holster_visual(primary, UPPER_BACK)
		update_holster_visual(secondary, RIGHT_HIP)

func set_sheathed(primary: WeaponData, secondary: WeaponData, is_sheathed: bool, last_slot: int) -> void:
	if is_sheathed:
		update_full_loadout(primary, secondary, -1)
	else:
		update_full_loadout(primary, secondary, last_slot)

func equip_weapon(weapon_data: WeaponData) -> Node3D:
	_clear_slot(RIGHT_HAND)
	
	if not weapon_data:
		_active_weapon_node = null
		return null

	var weapon_instance = _spawn_weapon_resource(weapon_data)
	if weapon_instance:
		RIGHT_HAND.add_child(weapon_instance)
		_active_weapon_node = weapon_instance
		_apply_transform(weapon_instance, weapon_data.right_hand_bone_transform)

		if _is_spawn_effect_active():
			_recursive_mesh_apply(weapon_instance, true, weapon_spawn_shader)

	return _active_weapon_node

## Updates the visual of a holstered weapon based on the specific bone slot
func update_holster_visual(weapon_data: WeaponData, slot: BoneAttachment3D) -> void:
	_clear_slot(slot)
		
	if weapon_data:
		var holster_instance = _spawn_weapon_resource(weapon_data)
		slot.add_child(holster_instance)
		holster_instance.set_process(false)
		
		# Auto-select the correct transform from WeaponData based on the slot provided
		var target_transform: TransformData = null
		if slot == RIGHT_HIP:
			target_transform = weapon_data.right_hip_bone_transform
		elif slot == UPPER_BACK:
			target_transform = weapon_data.upper_back_bone_transform
		elif slot == LOWER_BACK:
			target_transform = weapon_data.lower_back_bone_transform
			
		_apply_transform(holster_instance, target_transform)
		
		if _is_spawn_effect_active():
			_recursive_mesh_apply(holster_instance, true, weapon_spawn_shader)

func reset_visuals() -> void:
	set_spawn_visuals(false)
	SKELETON.visible = true
	if death_particles:
		death_particles.emitting = false

func trigger_death_visuals() -> void:
	SKELETON.visible = false
	if death_particles:
		death_particles.emitting = true

# ===
# Private Helpers
# ===

func _clear_slot(slot: Node) -> void:
	for child in slot.get_children():
		child.queue_free()

func _apply_transform(node: Node3D, data: TransformData) -> void:
	if not data: return
	
	node.position = data.position
	node.rotation_degrees = data.rotation
	node.scale = data.scale

func _apply_spawn_material(mesh: MeshInstance3D, active: bool, shader_res: Shader) -> void:
	if active:
		var original_mat = mesh.get_active_material(0)
		var new_mat = ShaderMaterial.new()
		new_mat.shader = shader_res
		
		# Inherit properties from the original material (textures/colors)
		if original_mat is ShaderMaterial:
			var params = ["red_color", "green_color", "blue_color", "albedo", "texture_albedo"]
			for p in params:
				var val = original_mat.get_shader_parameter(p)
				if val != null:
					new_mat.set_shader_parameter(p, val)
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

func _spawn_weapon_resource(weapon_data: WeaponData) -> Node3D:
	if weapon_data is GunData:
		var gun_instance = _gun_scene.instantiate()
		if gun_instance.has_method("set_gun_data"):
			gun_instance.set_gun_data(weapon_data)
		return gun_instance
	return null

func _is_spawn_effect_active() -> bool:
	return spawn_meshes.size() > 0 and spawn_meshes[0].material_override != null
