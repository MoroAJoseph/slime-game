extends Node3D

@export var spawn_meshes: Array[MeshInstance3D] = []
@export var player_spawn_shader: Shader

@onready var _skeleton: Skeleton3D = %GeneralSkeleton

var _current_spawn_height: float = -0.2

# ===
# Public
# ===

func update_spawn_visual(height_offset: float) -> void:
	_current_spawn_height = global_position.y + height_offset
	_propagate_spawn_height(self)

func set_spawn_visuals(active: bool) -> void:
	# Player
	for mesh in spawn_meshes:
		_apply_spawn_material(mesh, active, player_spawn_shader)
	
	# Weapons
	#var slots = [_right_hand, _right_hip, _upper_back, _lower_back ]
	#for slot in slots:
		#_recursive_mesh_apply(slot, active, weapon_spawn_shader)


func reset_visuals() -> void:
	set_spawn_visuals(false)
	_skeleton.visible = true
	#if death_particles:
		#death_particles.emitting = false

# ===
# Private
# ===

func _propagate_spawn_height(node: Node) -> void:
	if node is MeshInstance3D and node.material_override is ShaderMaterial:
		node.material_override.set_shader_parameter("spawn_height", _current_spawn_height)
	for child in node.get_children():
		_propagate_spawn_height(child)

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
