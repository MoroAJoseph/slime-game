class_name Hitbox
extends Area3D

@export var damage: float = 0.0
@export var knockback_force: float = 0.0

signal hit_sent(damage_data: DamageData)


func _init() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area3D) -> void:
	if area is Hurtbox:
		var hurtbox: Hurtbox = area
		var knockback_vector = global_transform.basis.z * knockback_force
		
		var damage_data = DamageData.new(damage, owner, global_position, knockback_vector)
		hurtbox.receive_hit(damage_data)
		hit_sent.emit(damage_data)
