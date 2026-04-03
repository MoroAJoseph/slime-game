@tool
class_name MeshVisual
extends MeshInstance3D


## This is the function the Assembler calls
func setup_visual(mesh_res: Mesh, r: Color, g: Color, b: Color) -> void:
	if not mesh_res:
		push_warning("MeshVisual: No mesh provided for " + name)
		return

	mesh = mesh_res
	
	# Apply the colors to the shader
	var current_material = get_surface_override_material(0)
	if current_material:
		current_material.set_shader_parameter("red_color", r)
		current_material.set_shader_parameter("green_color", g)
		current_material.set_shader_parameter("blue_color", b)
	else:
		push_warning("MeshVisual: No surface override material found on " + name)
