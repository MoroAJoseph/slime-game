class_name GazeTargetData
extends RefCounted

var identifier: GazeIdentifier
var position: Vector3
var distance: float
var ui_color: Color

func _init(_identifier: GazeIdentifier, _position: Vector3, _distance: float, _ui_color: Color):
	identifier = _identifier
	position = _position
	distance = _distance
	ui_color = _ui_color
