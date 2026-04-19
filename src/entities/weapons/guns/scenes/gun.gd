@tool
class_name Gun
extends Node3D

@onready var combat_controller: GunCombatController = $GunCombatController
@onready var model_controller: GunModelController = $GunModelController

func set_data(data: GunData) -> void:
	if !model_controller: model_controller = get_node_or_null("GunModelController")
	if !combat_controller: combat_controller = get_node_or_null("GunCombatController")
	
	if model_controller: 
		model_controller.rebuild(data)
	
	# Only run combat logic if we are actually playing the game
	if combat_controller and not Engine.is_editor_hint():
		combat_controller.initialize(data)

func shoot(direction: Vector3) -> void:
	if model_controller and combat_controller:
		var projectile_spawn: Transform3D = model_controller.get_projectile_spawn()
		combat_controller.shoot(direction, projectile_spawn)

func reload() -> void:
	if combat_controller:
		combat_controller.reload()
