# Dead
extends PlayerState

# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	# Kill all momentum
	_owner.velocity = Vector3.ZERO
	
	# Kill collision so cubes don't bounce off an invisible player
	_owner.collision_layer = 0 # Player
	_owner.collision_mask = 0 # World

func exit() -> void:
	_owner.collision_layer = 2 # Player
	_owner.collision_mask = 1 # World
