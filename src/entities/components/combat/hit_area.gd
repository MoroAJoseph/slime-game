class_name HitArea
extends Area3D

@export var damage: float = 0.0
@export var knockback_force: float = 0.0

signal sent(data: DamageData)


func _init() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D) -> void:
	if area is not HurtArea: return
	
	var knockback_vector = global_transform.basis.z * knockback_force
	var data = DamageData.new(damage, owner, global_position, knockback_vector)
	
	area.receive(data)
	sent.emit(data)
