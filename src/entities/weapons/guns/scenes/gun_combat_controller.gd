@tool
class_name GunCombatController
extends Node3D

@onready var bullet_scene: PackedScene = preload("res://entities/weapons/projectiles/bullets/bullet.tscn")

var _data: GunData
var _combat_data: GunCombatData
var current_ammo: int
var can_fire: bool = true
var is_reloading: bool = false

var _is_firing_auto: bool = false
var _last_direction: Vector3
var _last_spawn_transform: Transform3D

# ===
# Built-In
# ===

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if _is_firing_auto:
		_execute_fire_logic(_last_direction, _last_spawn_transform)

# ===
# Public
# ===

func initialize(data: GunData) -> void:
	_data = data
	_combat_data = _data.get_combat_data()
	current_ammo = _combat_data.ammo_capacity
	_publish_ammo()

func handle_fire_input(is_just_pressed: bool, is_held: bool, direction: Vector3, spawn_transform: Transform3D) -> void:
	_last_direction = direction
	_last_spawn_transform = spawn_transform
	
	var mode = _combat_data.fire_modes[0]
	
	match mode:
		GunResource.GunFireMode.SEMI_AUTO:
			if is_just_pressed:
				_execute_fire_logic(direction, spawn_transform)
		
		GunResource.GunFireMode.FULL_AUTO:
			_is_firing_auto = is_held
			if is_just_pressed:
				_execute_fire_logic(direction, spawn_transform)
				
		GunResource.GunFireMode.BURST:
			if is_just_pressed:
				_execute_burst(direction, spawn_transform)

func reload() -> void:
	if is_reloading or current_ammo == _combat_data.ammo_capacity: 
		return
	
	is_reloading = true
	WeaponEvent.ReloadUpdated.new(WeaponEvent.ReloadState.STARTED, _combat_data.reload_duration)
	
	await get_tree().create_timer(_combat_data.reload_duration).timeout
	
	if not is_inside_tree(): return

	current_ammo = _combat_data.ammo_capacity
	is_reloading = false
	_publish_ammo()
	WeaponEvent.ReloadUpdated.new(WeaponEvent.ReloadState.FINISHED, 0.0)

# ===
# Private
# ===

func _execute_fire_logic(direction: Vector3, spawn_transform: Transform3D) -> void:
	if not can_fire or is_reloading or current_ammo <= 0:
		if current_ammo <= 0 and not is_reloading: 
			reload()
		_is_firing_auto = false
		return

	_spawn_projectile(direction, spawn_transform)
	
	current_ammo -= 1
	can_fire = false
	
	var delay = 60.0 / _combat_data.fire_rate
	get_tree().create_timer(delay).timeout.connect(func(): can_fire = true)
	
	_publish_ammo()

func _execute_burst(direction: Vector3, spawn_transform: Transform3D) -> void:
	if not can_fire or is_reloading or current_ammo <= 0: return
	
	can_fire = false
	var burst_count = 3 # Can be moved to GunCombatData later
	var burst_delay = 0.06 
	var cycle_delay = 60.0 / _combat_data.fire_rate
	
	for i in range(burst_count):
		if current_ammo <= 0: break
		_spawn_projectile(direction, spawn_transform)
		current_ammo -= 1
		_publish_ammo()
		if i < burst_count - 1:
			await get_tree().create_timer(burst_delay).timeout
	
	get_tree().create_timer(cycle_delay).timeout.connect(func(): can_fire = true)

func _spawn_projectile(dir: Vector3, projectile_spawn: Transform3D) -> void:
	var bullet = bullet_scene.instantiate()
	
	var bucket = get_tree().get_first_node_in_group("projectile_bucket")
	if bucket:
		bucket.add_child(bullet)
	else:
		get_tree().root.add_child(bullet)

	var b_data = BulletData.new()
	b_data.damage = _combat_data.base_damage
	b_data.speed = _combat_data.bullet_velocity
	b_data.gravity_scale = 0.1
	b_data.lifetime = 3.0
	b_data.source_gun_data = _data 
	
	if bullet.has_method("initialize"):
		bullet.initialize(b_data, dir, projectile_spawn)

func _publish_ammo() -> void:
	WeaponEvent.ResourceUpdated.new(current_ammo, _combat_data.ammo_capacity)
