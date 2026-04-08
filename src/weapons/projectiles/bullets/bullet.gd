class_name BulletProjectile
extends Node3D

@export var _damage_number_scene: PackedScene

@onready var HIT_AREA: HitArea = $HitArea

var _data: BulletData
var _velocity: Vector3 = Vector3.ZERO
var _has_impacted: bool = false

## signature: (BulletData Object, Vector3 Direction, Transform3D Origin)
func initialize(bullet_data: BulletData, direction: Vector3, spawn_transform: Transform3D) -> void:
	_data = bullet_data
	global_transform = spawn_transform
	_velocity = direction.normalized() * _data.speed
	
	if _velocity.length() > 0:
		look_at(global_position + _velocity)
	
	get_tree().create_timer(_data.lifetime).timeout.connect(queue_free)
	
	if HIT_AREA:
		HIT_AREA.damage = _data.damage

func _physics_process(delta: float) -> void:
	# Safety check: Don't process if data isn't set yet or bullet has hit something
	if _has_impacted or _data == null: return
		
	if _data.gravity_scale > 0:
		_velocity.y -= 9.81 * _data.gravity_scale * delta
		look_at(global_position + _velocity)
	
	var step = _velocity * delta
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + step)
	query.collision_mask = 1
	
	var result = space_state.intersect_ray(query)
	
	if result:
		_handle_impact(result.position, false)
	else:
		global_position += step

func _on_hitbox_hit_sent(_damage_data) -> void:
	_handle_impact(global_position, true)

func _handle_impact(impact_position: Vector3, was_hurtbox: bool) -> void:
	if _has_impacted: return
	_has_impacted = true
	
	if was_hurtbox:
		_spawn_damage_number(impact_position, _data.damage)
	
	queue_free()

func _spawn_damage_number(pos: Vector3, amount: float) -> void:
	if not _damage_number_scene: return
	
	var camera = get_viewport().get_camera_3d()
	
	if camera:
		var indicator = _damage_number_scene.instantiate() as DamageNumber
		get_tree().root.add_child(indicator)
		indicator.spawn(amount, pos, camera)

func _spawn_impact_particles(_type: String) -> void:
	pass
