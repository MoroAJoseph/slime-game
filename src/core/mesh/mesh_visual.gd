@tool
class_name MeshVisual
extends MeshInstance3D

var material_instance: ShaderMaterial

func setup_visual(mesh_res: Mesh, r: Color, g: Color, b: Color, material_res: Material) -> void:
	if not mesh_res:
		push_warning("MeshVisual: No mesh provided for " + name)
		return

	self.mesh = mesh_res
	
	if material_res:
		material_instance = material_res
		
		self.set_surface_override_material(0, material_instance)
		
		material_instance.set_shader_parameter("red_color", r)
		material_instance.set_shader_parameter("green_color", g)
		material_instance.set_shader_parameter("blue_color", b)
	else:
		push_warning("MeshVisual: No material provided for " + name)

func clear_visual() -> void:
	self.mesh = null
	self.set_surface_override_material(0, null)
	self.material_override = null
	material_instance = null
