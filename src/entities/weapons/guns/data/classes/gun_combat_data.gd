@tool
class_name GunCombatData
extends GunResource

@export_group("Core")
@export var base_damage: float = 5.0
@export_range(0.0, 1.0) var crit_chance: float = 0.25
@export var weight: float = 1.0
@export var fire_rate: float = 600.0 # RPM
@export var fire_modes: Array[GunFireMode] = [GunFireMode.SEMI_AUTO]

@export_group("Physics & Projectile")
@export var bullet_velocity: float = 70.0
@export var bullet_spread: float = 0.02
@export var effective_range: float = 100.0

@export_group("Economy")
@export var ammo_capacity: int = 30
@export var reload_duration: float = 2.0

@export_group("Handling & Recoil")
@export var vertical_recoil: float = 1.0
@export var recoil_recovery: float = 5.0
@export var idle_sway: float = 1.0
@export var ads_duration: float = 0.3
@export var aim_magnification: float = 1.0

@export_group("Visuals & Audio")
@export var muzzle_flash_intensity: float = 1.0
@export var acoustic_range: float = 50.0
