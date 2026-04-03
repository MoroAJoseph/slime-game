@tool
class_name EntitySpawnPoint
extends Marker3D

# TODO: Button to force Y position to the nearest collision shape in Y
# TODO: Button to preview instanced entity based based on data passed

var entity_data: EntityData:
	set(value):
		if entity_data and entity_data.is_connected("changed", _update_editor_visuals):
			entity_data.disconnect("changed", _update_editor_visuals)
		
		entity_data = value
		
		if entity_data:
			entity_data.connect("changed", _update_editor_visuals)
			
		_update_editor_visuals()

var _editor_visual: MeshInstance3D
var _arrow_mesh: MeshInstance3D
var _label: Label3D

# ===
# Built-In
# ===

func _ready() -> void:
	if Engine.is_editor_hint():
		_setup_editor_visuals()
	else:
		for child in get_children():
			child.queue_free()

# === 
# Local
# ===

func _setup_editor_visuals() -> void:
	if get_child_count() > 0: return 
	
	# --- Platform Disc ---
	_editor_visual = MeshInstance3D.new()
	var disc = CylinderMesh.new()
	disc.top_radius = 0.5
	disc.bottom_radius = 0.5
	disc.height = 0.05
	_editor_visual.mesh = disc
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_editor_visual.material_override = mat
	add_child(_editor_visual)
	
	# --- Directional Pointer ---
	_arrow_mesh = MeshInstance3D.new()
	var prism = PrismMesh.new()
	# Size: X (Width), Y (Length of pointer), Z (Thickness)
	prism.size = Vector3(0.4, 0.6, 0.05) 
	_arrow_mesh.mesh = prism
	
	# Rotation: X - Lay Flat, Y - Point Forward
	_arrow_mesh.rotation_degrees = Vector3(90, -180, 0)
	
	# Position
	_arrow_mesh.position = Vector3(0, 0.03, -0.6) 
	
	var arrow_mat = StandardMaterial3D.new()
	arrow_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_arrow_mesh.material_override = arrow_mat
	add_child(_arrow_mesh)
	
	# --- Label ---
	_label = Label3D.new()
	_label.pixel_size = 0.005
	_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_label.position.y = 1.0
	_label.no_depth_test = true 
	add_child(_label)
	
	_update_editor_visuals()

func _update_editor_visuals() -> void:
	if not _label or not is_inside_tree(): return
	
	var color = _get_spawn_color()
	_label.text = _get_spawn_label()
	
	if _editor_visual:
		_editor_visual.material_override.albedo_color = color
		_editor_visual.material_override.albedo_color.a = 0.4
	
	if _arrow_mesh:
		_arrow_mesh.material_override.albedo_color = color

func _get_spawn_color() -> Color:
	return Color.WHITE

func _get_spawn_label() -> String:
	return entity_data.name if entity_data else "EMPTY"
