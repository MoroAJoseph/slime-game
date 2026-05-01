extends SlimeState

@export var chunk_scene: PackedScene

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	_owner.velocity = Vector3.ZERO
	
	for i in range(8):
		var chunk = chunk_scene.instantiate()
		get_tree().root.add_child(chunk)
		
		# Offset spawn to avoid physics clipping
		var spawn_offset = Vector3(randf_range(-0.2, 0.2), 0.3, randf_range(-0.2, 0.2))
		chunk.global_position = _owner.global_position + spawn_offset
		
		# Scale and Mass
		var s = randf_range(0.4, 0.8) # Slightly larger minimum scale for visibility
		chunk.scale = Vector3(s, s, s)
		chunk.mass = s * 2.0 
		
		# Rotation
		chunk.rotation = Vector3(randf_range(0, TAU), randf_range(0, TAU), randf_range(0, TAU))
		
		# PHYSICS: THE "ZAC" BURST
		# Increased horizontal range (-1.0 to 1.0) for a wider radius
		# Increased vertical range (0.5 to 1.2) for a higher arc
		var direction = Vector3(
			randf_range(-1.0, 1.0), 
			randf_range(0.5, 1.2), 
			randf_range(-1.0, 1.0)
		).normalized()
		
		# Increased force multiplier (8.0 to 12.0) to launch them farther
		var force = chunk.mass * randf_range(8.0, 12.0) 
		
		chunk.apply_central_impulse(direction * force)
		# Higher torque for a more chaotic "jiggling" flight
		chunk.apply_torque_impulse(Vector3(randf(), randf(), randf()) * 0.5)

	_owner.queue_free()
