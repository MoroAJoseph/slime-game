class_name DamageData
extends RefCounted

var amount: float
var attacker: Node3D
var hit_position: Vector3
var knockback_force: Vector3

func _init(p_amount: float, p_attacker: Node3D, p_position: Vector3, p_knockback_vector: Vector3):
	amount = p_amount
	attacker = p_attacker
	hit_position = p_position
	knockback_force = p_knockback_vector
