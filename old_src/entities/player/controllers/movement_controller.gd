class_name PlayerMovementController
extends Node

@onready var player: Player = get_parent()

var _last_movement_direction: Vector3 = Vector3.BACK

# ===
# Public
# ===

func apply_movement(input_dir: Vector2, cam_basis: Basis, delta: float) -> void:
	var move_dir = (cam_basis.x * -input_dir.x) + (cam_basis.z * -input_dir.y)
	move_dir.y = 0.0
	
	if move_dir.length() > 0.1:
		move_dir = move_dir.normalized()
		_last_movement_direction = move_dir
		
		# Acceleration logic using PlayerData
		player.velocity.x = move_toward(player.velocity.x, move_dir.x * player.data.run_speed, player.data.acceleration * delta)
		player.velocity.z = move_toward(player.velocity.z, move_dir.z * player.data.run_speed, player.data.acceleration * delta)
	else:
		# Friction/Deceleration
		player.velocity.x = move_toward(player.velocity.x, 0, player.data.friction * delta)
		player.velocity.z = move_toward(player.velocity.z, 0, player.data.friction * delta)

	# Gravity logic
	if not player.is_on_floor():
		player.velocity.y += player.data.gravity * delta
	else:
		player.velocity.y = 0
		
	player.move_and_slide()

func get_last_move_dir() -> Vector3:
	return _last_movement_direction
