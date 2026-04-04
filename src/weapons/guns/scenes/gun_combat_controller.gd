@tool
class_name GunCombatController
extends Node3D

@onready var bullet_scene: PackedScene = preload("res://weapons/projectiles/bullets/bullet.tscn")

var _data: GunData
var _combat_data: GunCombatData
var current_ammo: int
var can_fire: bool = true
var is_reloading: bool = false

func initialize(data: GunData) -> void:
	_data = data
	_combat_data = _data.get_combat_data()
	current_ammo = _combat_data.ammo_capacity
	_publish_ammo()

func shoot(direction: Vector3, projectile_spawn: Transform3D) -> void:
	if not can_fire or is_reloading or current_ammo <= 0:
		if current_ammo <= 0 and not is_reloading: reload()
		return

	_spawn_projectile(direction, projectile_spawn)
	
	current_ammo -= 1
	can_fire = false
	
	# RPM to Cooldown: 60 / RPM = seconds per shot
	var delay = 60.0 / _combat_data.fire_rate
	get_tree().create_timer(delay).timeout.connect(func(): can_fire = true)
	
	_publish_ammo()

func _spawn_projectile(dir: Vector3, projectile_spawn: Transform3D) -> void:
	# Ensure bullet scene is valid in tool mode
	if not bullet_scene:
		bullet_scene = load("res://weapons/projectiles/bullets/bullet.tscn")
		
	var bullet = bullet_scene.instantiate()
	
	# 1. Add to the global projectile bucket
	var bucket = get_tree().get_first_node_in_group("projectile_bucket")
	if bucket:
		bucket.add_child(bullet)
	else:
		get_tree().root.add_child(bullet)
		push_warning("GunCombatController: 'projectile_bucket' group not found. Spawning at root.")

	# 2. Package stats into a BulletData Object (fixes the Type Error)
	var b_data = BulletData.new()
	b_data.damage = _combat_data.base_damage
	b_data.speed = _combat_data.bullet_velocity
	b_data.gravity_scale = 0.1 # Default or from stats
	b_data.lifetime = 3.0      # Default or from stats
	b_data.source_gun_data = _data # Pass the GunData for impact logic
	
	# 3. Initialize the bullet with the correct Object/Vector/Transform signature
	if bullet.has_method("initialize"):
		bullet.initialize(b_data, dir, projectile_spawn)

func reload() -> void:
	# Validation: Don't reload if already in progress or ammo is already full
	if is_reloading or current_ammo == _combat_data.ammo_capacity: 
		return
	
	is_reloading = true
	EventBus.publish(EventBus.PlayerEvent.ReloadStarted.new(_combat_data.reload_duration))
	
	await get_tree().create_timer(_combat_data.reload_duration).timeout
	
	if not is_inside_tree(): 
		return

	current_ammo = _combat_data.ammo_capacity
	is_reloading = false
	_publish_ammo()
	EventBus.publish(EventBus.PlayerEvent.ReloadFinished.new())

func _publish_ammo() -> void:
	EventBus.publish(EventBus.PlayerEvent.AmmoUpdated.new(current_ammo, _combat_data.ammo_capacity))
