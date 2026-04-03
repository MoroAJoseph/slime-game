class_name Gun
extends Node

@export var data: GunData
@export var _bullet_projectile_scene: PackedScene
@export var _bullet_projectile_spawn_node: Marker3D 

var current_ammo: int
var can_fire: bool = true
var is_reloading: bool = false

# ===
# Built-In
# ===

func _ready() -> void:
	if data:
		current_ammo = data.mag_capacity
		_publish_ammo()

# ===
# Local
# ===

func set_data(value: GunData) -> void:
	data = value
	current_ammo = data.mag_capacity
	_publish_ammo()

func shoot(facing_direction: Vector3) -> void:
	if not can_fire or is_reloading or current_ammo <= 0:
		if current_ammo <= 0 and not is_reloading:
			reload()
		return
	
	_spawn_projectile(facing_direction)
	current_ammo -= 1
	can_fire = false
	
	EventBus.publish(EventBus.PlayerEvent.FiredGun.new(data))
	_publish_ammo()
	
	var cooldown_duration = 1.0 / data.fire_rate
	get_tree().create_timer(cooldown_duration).timeout.connect(
		func(): can_fire = true
	)

func reload() -> void:
	if is_reloading or current_ammo == data.mag_capacity: 
		return
	
	is_reloading = true
	EventBus.publish(EventBus.PlayerEvent.ReloadStarted.new(data.reload_time))
	
	await get_tree().create_timer(data.reload_time).timeout
	
	if not is_inside_tree(): return

	current_ammo = data.mag_capacity
	is_reloading = false
	can_fire = true

	EventBus.publish(EventBus.PlayerEvent.ReloadFinished.new())
	_publish_ammo()

func _publish_ammo() -> void:
	EventBus.publish(EventBus.PlayerEvent.AmmoUpdated.new(current_ammo, data.mag_capacity))

func _spawn_projectile(facing_direction: Vector3) -> void:
	if not _bullet_projectile_scene: return
	
	var bullet = _bullet_projectile_scene.instantiate()
	
	var b_data = BulletData.new()
	b_data.speed = 70.0 
	b_data.source_gun_data = data 
	
	var final_damage = data.base_damage
	if randf() <= data.crit_chance:
		final_damage *= 2.0
	
	b_data.damage = final_damage
	
	var bucket = get_tree().get_first_node_in_group("projectile_bucket")
	if bucket: bucket.add_child(bullet)
	else: get_tree().root.add_child(bullet)
	
	bullet.global_position = _bullet_projectile_spawn_node.global_position
	
	if bullet.has_method("initialize"):
		bullet.initialize(b_data, facing_direction)
