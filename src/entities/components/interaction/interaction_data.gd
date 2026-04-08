class_name InteractionData
extends RefCounted

var interactor: Node3D
var target: Node3D

func _init(p_interactor: Node3D, p_target: Node3D):
	interactor = p_interactor
	target = p_target
