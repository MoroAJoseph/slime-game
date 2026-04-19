@tool
class_name Gun
extends Node3D

@onready var combat_controller: GunCombatController = $GunCombatController
@onready var model_controller: GunModelController = $GunModelController

# ===
# Public
# ===

func set_data(data: GunData) -> void:
	if !model_controller: model_controller = get_node_or_null("GunModelController")
	if !combat_controller: combat_controller = get_node_or_null("GunCombatController")
	
	if model_controller: 
		model_controller.rebuild(data)
	
	if combat_controller and not Engine.is_editor_hint():
		combat_controller.initialize(data)

func request_fire(is_just_pressed: bool, is_held: bool, direction: Vector3, spawn_transform: Transform3D) -> void:
	if combat_controller:
		combat_controller.handle_fire_input(is_just_pressed, is_held, direction, spawn_transform)

func get_projectile_spawn() -> Transform3D:
	if model_controller:
		return model_controller.get_projectile_spawn()
	return global_transform

func reload() -> void:
	if combat_controller:
		combat_controller.reload()
