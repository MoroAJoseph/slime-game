class_name BulletProjectile
extends Node3D

@export var _damage_number_scene: PackedScene

@onready var _damage_detector: DamageDetector = $DamageDetector

# TODO CRITICAL: Bullet hits the player

var _data: BulletData
var _velocity: Vector3 = Vector3.ZERO
var _has_impacted: bool = false

# ===
# Built-In
# ===

func _physics_process(delta: float) -> void:
	if _has_impacted or not _data:
		return
		
	if _data.gravity_scale > 0:
		_velocity.y -= 9.81 * _data.gravity_scale * delta
		if _velocity.length() > 0:
			look_at(global_position + _velocity)
	
	var step = _velocity * delta
	var impact = _damage_detector.check_impact(step, _data.damage)
	
	if impact.hit:
		_handle_impact(impact.position, impact.was_sensor)
	else:
		global_position += step

# ===
# Public
# ===

func initialize(bullet_data: BulletData, direction: Vector3, spawn_transform: Transform3D) -> void:
	_data = bullet_data
	global_transform = spawn_transform
	_velocity = direction.normalized() * _data.speed
	
	if _velocity.length() > 0:
		look_at(global_position + _velocity)
	
	get_tree().create_timer(_data.lifetime).timeout.connect(queue_free)

# ===
# Private
# ===

func _handle_impact(impact_position: Vector3, was_damage_sensor: bool) -> void:
	if _has_impacted: return
	
	_has_impacted = true
	
	if was_damage_sensor:
		_spawn_damage_number(impact_position, _data.damage)
	
	queue_free()

func _spawn_damage_number(pos: Vector3, amount: float) -> void:
	if not _damage_number_scene: return
	
	var indicator = _damage_number_scene.instantiate() as DamageNumber
	get_tree().root.add_child(indicator)
	
	var camera = get_viewport().get_camera_3d()
	if camera:
		indicator.spawn(amount, pos, camera)
