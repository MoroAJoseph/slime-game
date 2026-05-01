# Idle
extends SlimeState


# ===
# Parent
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	_owner.velocity.x = 0.0
	_owner.velocity.y = 0.0
