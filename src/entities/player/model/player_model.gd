class_name PlayerModelController
extends Node3D


@export_group("Spawn Settings")
@export var spawn_meshes: Array[MeshInstance3D] = []
@export var spawn_shader: Shader

@export_group("Death Settings")
@export var death_particles: GPUParticles3D 

@onready var SKELETON: Skeleton3D = $Armature/GeneralSkeleton
@onready var RIGHT_HAND: BoneAttachment3D = $Armature/GeneralSkeleton/RIGHT_HAND

# === 
# Local
# ===

# TODO Pass PlayerLoadoutData
func setup_weapons(gun_data: GunData) -> void:
	# TODO Dynamically render rifle slot if player has a rifle equipped
	var current_cun: Gun = get_current_gun()
	current_cun.set_data(gun_data)

func get_current_gun() -> Gun:
	if RIGHT_HAND.get_child_count() > 0:
		return RIGHT_HAND.get_child(0) as Gun
	return null

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
