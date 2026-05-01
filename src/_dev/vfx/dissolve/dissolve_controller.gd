@tool
extends MeshInstance3D

@export_tool_button("Update Bounds", "Callable") var update_bounds_button = _update_bounds

var last_position: Vector3 = Vector3.ZERO
var last_direction: Vector3 = Vector3.ZERO
var last_invert: bool = false

func _ready():
	_update_bounds()
	last_position = global_position
	
	var mat = get_active_material(0) as ShaderMaterial
	if mat:
		last_direction = mat.get_shader_parameter("dissolve_direction")
		last_invert = mat.get_shader_parameter("invert_direction")

func _process(_delta):
	var mat = get_active_material(0) as ShaderMaterial
	if not mat:
		return
	
	var current_direction: Vector3 = mat.get_shader_parameter("dissolve_direction")
	var current_invert: bool = mat.get_shader_parameter("invert_direction")
	
	if current_direction == null:
		current_direction = Vector3(0, 1, 0)
	if current_invert == null:
		current_invert = false
	
	# Update bounds if position, direction, or invert changed
	if (global_position != last_position or 
		current_direction != last_direction or
		current_invert != last_invert):
		_update_bounds()
		last_position = global_position
		last_direction = current_direction
		last_invert = current_invert

func _update_bounds():
	var mat = get_active_material(0) as ShaderMaterial
	if not mat:
		return
	
	# Get local mesh AABB
	var aabb = mesh.get_aabb() if mesh else get_aabb()
	
	# Get dissolve direction from shader
	var direction: Vector3 = mat.get_shader_parameter("dissolve_direction")
	if direction == null:
		direction = Vector3(0, 1, 0)
	
	var invert: bool = mat.get_shader_parameter("invert_direction")
	if invert == null:
		invert = false
	
	# Get noise strength and edge width to pad the bounds
	var noise_strength: float = mat.get_shader_parameter("noise_strength")
	if noise_strength == null:
		noise_strength = 0.25
	
	var edge_width: float = mat.get_shader_parameter("edge_width")
	if edge_width == null:
		edge_width = 0.05
	
	# Calculate padding needed
	var padding = noise_strength + edge_width
	
	# For combined directions, calculate bounds based on dot product range
	var dir = direction.normalized()
	
	# Get all 8 corners of the AABB in world space
	var corners = [
		aabb.position,
		aabb.position + Vector3(aabb.size.x, 0, 0),
		aabb.position + Vector3(0, aabb.size.y, 0),
		aabb.position + Vector3(0, 0, aabb.size.z),
		aabb.position + Vector3(aabb.size.x, aabb.size.y, 0),
		aabb.position + Vector3(aabb.size.x, 0, aabb.size.z),
		aabb.position + Vector3(0, aabb.size.y, aabb.size.z),
		aabb.end
	]
	
	# Project each corner onto the dissolve direction and find min/max
	var bounds_min = INF
	var bounds_max = -INF
	
	for corner in corners:
		# Transform to world space
		var world_corner = global_position + corner
		
		# Project onto dissolve direction (same as shader calculation)
		var projection = world_corner.x * abs(dir.x) + world_corner.y * abs(dir.y) + world_corner.z * abs(dir.z)
		
		bounds_min = min(bounds_min, projection)
		bounds_max = max(bounds_max, projection)
	
	# Expand bounds by padding to ensure full dissolve
	bounds_min -= padding
	bounds_max += padding
	
	# Set to shader
	mat.set_shader_parameter("object_min", bounds_min)
	mat.set_shader_parameter("object_max", bounds_max)
	
	print("Bounds updated: ", bounds_min, " to ", bounds_max, " (padding: ", padding, ")")
