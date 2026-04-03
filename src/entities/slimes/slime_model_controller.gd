class_name SlimeModelController
extends ModelController

@onready var _body_mesh: MeshInstance3D = $SoftRig/GeneralSkeleton/Body
@onready var _body_highlight: MeshInstance3D = $SoftRig/GeneralSkeleton/Highlights
@onready var _eyes: MeshInstance3D = $SoftRig/GeneralSkeleton/Eyes

func apply_slime_color(new_color: Color) -> void:
	_set_mesh_color(_body_mesh, new_color)
	_set_mesh_color(_body_highlight, new_color.lightened(0.3))
	# _set_mesh_color(_eyes, Color.BLACK)

func _set_mesh_color(mesh_node: MeshInstance3D, color: Color) -> void:
	if not mesh_node: return
	
	var material = mesh_node.get_active_material(0)
	
	if material is StandardMaterial3D or material is ORMMaterial3D:
		var new_mat = material.duplicate()
		new_mat.albedo_color = color
		mesh_node.set_surface_override_material(0, new_mat)
