@tool
extends Node3D

@export_group("Editor Tools")
@export var generate_world: bool = false:
	set(val): _build()

@export_group("Dimensions")
@export var map_size: float = 400.0 
@export var mesh_res: int = 250 

@export_group("Jaggedness")
@export var vertical_scale: float = 70.0
@export var cellular_jitter: float = 1.0 # 1.0 = Max rock fracturing
@export var rock_frequency: float = 0.02

@export_group("Colors")
@export var floor_color := Color("1a1a2e")
@export var wall_color := Color("e94560")

func _build():
	# 1. Standard Purge
	for child in get_children(): child.free()
	
	# 2. Setup Rock Noise (Cellular for sharp facets)
	var noise = FastNoiseLite.new()
	noise.seed = Time.get_ticks_msec()
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.frequency = rock_frequency
	noise.cellular_jitter = cellular_jitter
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = 5

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var step = map_size / mesh_res

	# 3. GENERATE JAGGED VERTICES
	for z in range(mesh_res + 1):
		for x in range(mesh_res + 1):
			var x_p = (x * step) - (map_size / 2.0)
			var z_p = (z * step) - (map_size / 2.0)
			
			var n = noise.get_noise_2d(x_p, z_p)
			
			# MATHEMATICAL CAVE CARVING
			# We use a secondary noise to "punch holes" in the Y-calc
			var cave_noise = noise.get_noise_3d(x_p * 2, 0, z_p * 2)
			var y_p = _get_jagged_y(n)
			
			# If cave noise is extremely high, we drop the Y to create a "Pit Cave"
			if cave_noise > 0.4:
				y_p -= 15.0 

			# Calculate Normals for the Sharp Rock Look
			var y_r = _get_jagged_y(noise.get_noise_2d(x_p + 0.2, z_p))
			var y_f = _get_jagged_y(noise.get_noise_2d(x_p, z_p + 0.2))
			var norm = Vector3(0.2, y_r - y_p, 0).cross(Vector3(0, y_f - y_p, 0.2)).normalized()
			
			# Color: If steep, it's Wall. If low/flat, it's Floor.
			var is_floor = (norm.dot(Vector3.UP) > 0.65 or y_p < -5.0)
			st.set_color(floor_color if is_floor else wall_color)
			st.set_normal(norm)
			st.add_vertex(Vector3(x_p, y_p, z_p))

	# 4. INDEXING
	for z in range(mesh_res):
		for x in range(mesh_res):
			var i = x + z * (mesh_res + 1)
			st.add_index(i); st.add_index(i + 1); st.add_index(i + mesh_res + 1)
			st.add_index(i + 1); st.add_index(i + mesh_res + 2); st.add_index(i + mesh_res + 1)

	# 5. FINAL COMMIT (No CSG to break things)
	st.generate_normals()
	var mi = MeshInstance3D.new()
	mi.mesh = st.commit()
	add_child(mi)
	mi.owner = get_tree().edited_scene_root
	
	var mat = StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 1.0
	mi.material_override = mat
	mi.create_trimesh_collision()

	_spawn_spaced_labs(noise)

func _get_jagged_y(n: float) -> float:
	# Forces the heights to be more angular and sharp
	if n < 0:
		return n * vertical_scale * 0.4
	return pow(n, 0.4) * vertical_scale # Low exponent = sharp, plateau-like peaks

func _spawn_spaced_labs(noise):
	var colors = [Color.GREEN, Color.CYAN, Color.GOLD, Color.PURPLE, Color.ORANGE]
	var lab_pos = []
	
	for i in range(5):
		var rx = randf_range(-map_size/3, map_size/3)
		var rz = randf_range(-map_size/3, map_size/3)
		var n = noise.get_noise_2d(rx, rz)
		var y_p = _get_jagged_y(n)
		
		var pos = Vector3(rx, y_p, rz)
		
		# Spacing Check
		var too_close = false
		for p in lab_pos:
			if pos.distance_to(p) < 80.0: too_close = true; break
		
		if not too_close:
			_create_simple_lab(pos, colors[i])
			lab_pos.append(pos)

func _create_simple_lab(pos: Vector3, col: Color):
	var sb = StaticBody3D.new()
	add_child(sb)
	sb.position = pos
	
	var mi = MeshInstance3D.new()
	mi.mesh = BoxMesh.new()
	mi.mesh.size = Vector3(14, 8, 20)
	sb.add_child(mi)
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = col
	mi.material_override = mat
	
	var coll = CollisionShape3D.new()
	coll.shape = BoxShape3D.new()
	coll.shape.size = mi.mesh.size
	sb.add_child(coll)
	
	sb.owner = get_tree().edited_scene_root
	mi.owner = get_tree().edited_scene_root
	coll.owner = get_tree().edited_scene_root
