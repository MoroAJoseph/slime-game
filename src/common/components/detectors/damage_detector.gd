class_name DamageDetector
extends Detector

var _damage_payload: float = 0.0

# ===
# Public
# ===

func check_impact(step: Vector3, payload: float) -> Dictionary:
	_damage_payload = payload
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + step)
	
	query.collision_mask = Constants.LAYER_PHYSICS_3D["Damage"]
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	
	if result:
		global_position = result.position
		var was_sensor = _process_impact()
		return {"hit": true, "position": result.position, "was_sensor": was_sensor}
		
	return {"hit": false}

# ===
# Private
# ===

func _should_detect(sensor: Sensor) -> bool:
	return sensor is DamageSensor

func _process_impact() -> bool:
	var space_state = get_world_3d().direct_space_state
	var shape_query = PhysicsShapeQueryParameters3D.new()
	
	var collision_shape = get_child(0) as CollisionShape3D
	if not collision_shape: return false
	
	shape_query.shape = collision_shape.shape
	shape_query.transform = global_transform
	shape_query.collision_mask = collision_mask
	shape_query.collide_with_areas = true
	
	var results = space_state.intersect_shape(shape_query)
	var hit_sensor = false
	
	for collision in results:
		var area = collision.collider
		if area is DamageSensor and _should_detect(area):
			_on_area_entered(area)
			hit_sensor = true
			
	return hit_sensor

# ===
# Signals
# ===

func _on_area_entered(area: Area3D) -> void:
	super._on_area_entered(area)
	
	if area is DamageSensor:
		var d_data = DamageData.new(
			_damage_payload,
			get_parent(),
			global_position,
			global_transform.basis.z
		)
		area.receive(d_data)
		entered.emit(area)
