class_name GazeTargetData
extends RefCounted

var sensor: GazeSensor
var position: Vector3
var distance: float
var ui_color: Color

func _init(_sensor: GazeSensor, _position: Vector3, _distance: float, _ui_color: Color):
	sensor = _sensor
	position = _position
	distance = _distance
	ui_color = _ui_color
