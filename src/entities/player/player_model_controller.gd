class_name PlayerModelController
extends Node3D

@export_group("Spawn")
@export var spawn_meshes: Array[MeshInstance3D] = []
@export var spawn_shader: Shader

@export_group("Death")
@export var death_particles: GPUParticles3D 

@onready var _gun_scene: PackedScene = preload("res://weapons/guns/scenes/gun.tscn")

# Bones
@onready var SKELETON: Skeleton3D = $Armature/GeneralSkeleton
@onready var RIGHT_HAND: BoneAttachment3D = $Armature/GeneralSkeleton/RIGHT_HAND
@onready var UPPER_BACK: BoneAttachment3D = $Armature/GeneralSkeleton/UPPER_BACK

var _active_weapon_node: Node3D
var _holstered_weapon_node: Node3D

# ===
# Built-In
# ===

func _ready() -> void:
	pass

# ===
# Local
# ===

## Removes current children from the hand and instantiates the new weapon scene
func equip_weapon(weapon_data: WeaponData) -> Node3D:
	# Clear current hand visuals
	for child in RIGHT_HAND.get_children():
		child.queue_free()
	
	if not weapon_data:
		_active_weapon_node = null
		return null

	# Instantiate the weapon visual
	var weapon_instance = _spawn_weapon_resource(weapon_data)
	if weapon_instance:
		RIGHT_HAND.add_child(weapon_instance)
		_active_weapon_node = weapon_instance
		
		# APPLY TRANSFORM & SCALE
		if weapon_data.hand_bone_transform:
			weapon_instance.position = weapon_data.hand_bone_transform.position
			weapon_instance.rotation_degrees = weapon_data.hand_bone_transform.rotation
			weapon_instance.scale = weapon_data.hand_bone_transform.scale
		else:
			# Safety default: If no transform data, ensure scale is at least 1,1,1
			weapon_instance.scale = Vector3.ONE

	return _active_weapon_node

func _spawn_weapon_resource(weapon_data: WeaponData) -> Node3D:
	if weapon_data is GunData:
		var gun_instance = _gun_scene.instantiate()
		if gun_instance.has_method("set_gun_data"):
			gun_instance.set_gun_data(weapon_data)
		return gun_instance
	
	# Add melee/sword instantiation here later
	return null

func update_holster_visual(weapon_data: WeaponData) -> void:
	for child in UPPER_BACK.get_children():
		child.queue_free()
		
	if weapon_data:
		var holster_instance = _spawn_weapon_resource(weapon_data)
		UPPER_BACK.add_child(holster_instance)
		# Disable processing/collision on holstered items if necessary
		holster_instance.set_process(false)

func set_spawn_visuals(active: bool) -> void:
	for mesh in spawn_meshes:
		if active:
			var original_mat = mesh.get_active_material(0)
			var new_mat = ShaderMaterial.new()
			new_mat.shader = spawn_shader
			if original_mat is StandardMaterial3D:
				new_mat.set_shader_parameter("albedo", original_mat.albedo_color)
				new_mat.set_shader_parameter("texture_albedo", original_mat.albedo_texture)
			mesh.material_override = new_mat
		else:
			mesh.material_override = null

func trigger_death_visuals() -> void:
	SKELETON.visible = false 
	
	if death_particles:
		var process_material = death_particles.process_material as ParticleProcessMaterial
		process_material.gravity = Vector3.ZERO
		death_particles.visible = true
		death_particles.restart()
		death_particles.emitting = true
		
		var timer = get_tree().create_timer(0.5)
		timer.timeout.connect(func():
			process_material.gravity = Vector3(0, -12.0, 0)
		)

func reset_visuals() -> void:
	for mesh in spawn_meshes:
		mesh.material_override = null
	
	SKELETON.visible = true
	
	if death_particles:
		death_particles.visible = false
		death_particles.emitting = false

# ===
# Events
# ===

# ===
# Signals
# ===
