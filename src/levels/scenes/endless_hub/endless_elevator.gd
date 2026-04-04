class_name EndlessHubElevator
extends Node3D

enum Floor { ATRIUM, FORGE, BIO_LAB, RANGE }

@export var initial_floor: Floor
@export var atrium_marker: Marker3D
@export var forge_marker: Marker3D
@export var biolab_marker: Marker3D
@export var range_marker: Marker3D

@onready var STATE_MACHINE: StateMachine = $StateMachine
@onready var ANIMATION_PLAYER: AnimationPlayer = $AnimationPlayer
@onready var MENU = $ElevatorMenu3D
@onready var floor_map: Dictionary = {
	Floor.ATRIUM: atrium_marker,
	Floor.FORGE: forge_marker,
	Floor.BIO_LAB: biolab_marker,
	Floor.RANGE: range_marker
}

var _player_inside: bool = false

func _ready() -> void:
	MENU.hide()
	
	# Connect signals and initialize UI
	if MENU:
		MENU.floor_selected.connect(_on_menu_floor_selected)
		
		var ui_2d = MENU.ui_menu
		if ui_2d:
			# Set the initial button state
			ui_2d.set_current_floor(initial_floor)
	
	# Initialize States
	for child in STATE_MACHINE.get_children():
		if child is EndlessElevatorState:
			child.setup(self)

func _on_menu_floor_selected(index: int) -> void:
	if STATE_MACHINE.state.name == "Idle":
		# Look up the target marker using the dictionary
		var target_marker = floor_map.get(index as Floor)
		
		if target_marker:
			var target_pos = target_marker.global_position
			var transit_data = ElevatorTransitData.new(index, target_pos)
			STATE_MACHINE._transition_to_next_state("Transit", transit_data)
		else:
			push_error("Elevator: No marker found for floor index %d" % index)

func _on_player_detector_body_entered(body: Node3D) -> void:
	if body is Player:
		_player_inside = true
		MENU.show()

func _on_player_detector_body_exited(body: Node3D) -> void:
	if body is Player:
		_player_inside = false
		MENU.hide()
