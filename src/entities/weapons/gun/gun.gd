@tool
class_name Gun
extends Node3D

@onready var _combat_controller: GunCombatController = $CombatController
@onready var _model_controller: GunModelController = $ModelController
@onready var _state_machine: StateMachine = $StateMachine

# ===
# Public
# ===

func set_data(data: GunData) -> void:
	if !_model_controller: _model_controller = get_node_or_null("ModelController")
	if !_combat_controller: _combat_controller = get_node_or_null("CombatController")
	
	if _model_controller: 
		_model_controller.rebuild(data)
	
	if _combat_controller and not Engine.is_editor_hint():
		_combat_controller.initialize(data)

func request_fire(is_just_pressed: bool, is_held: bool, direction: Vector3, spawn_transform: Transform3D) -> void:
	if _combat_controller:
		_combat_controller.handle_fire_input(is_just_pressed, is_held, direction, spawn_transform)

func get_projectile_spawn() -> Transform3D:
	if _model_controller:
		return _model_controller.get_projectile_spawn()
	return global_transform

func reload() -> void:
	if _combat_controller:
		_combat_controller.reload()
