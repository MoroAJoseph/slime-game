extends RigidBody3D

@export var splatter_scene: PackedScene

func _ready() -> void:
	# Double-check code-side just in case Inspector missed it
	contact_monitor = true
	max_contacts_reported = 5
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	
	# Only splat on environment
	if body is StaticBody3D or body is GridMap or body is CSGBox3D:
		spawn_splat()
		queue_free() # This MUST remove the chunk

func spawn_splat() -> void:
	var splat = splatter_scene.instantiate()
	get_tree().root.add_child(splat)
	
	# Position and force a downward projection
	splat.global_position = global_position
	splat.rotation_degrees = Vector3(-90, randf_range(0, 360), 0)
	
	# Ensure visibility
	if splat is Decal:
		splat.size = Vector3(2, 4, 2)
		splat.upper_fade = 0.0
		splat.lower_fade = 0.0
	
	# Pop-in animation
	var s = scale.x * 2.0
	var tween = create_tween()
	splat.scale = Vector3.ZERO
	tween.tween_property(splat, "scale", Vector3(s, s, s), 0.1)
