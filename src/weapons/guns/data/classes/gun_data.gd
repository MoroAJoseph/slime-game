@tool
class_name GunData
extends WeaponData

@export var type: GunResource.GunType
@export var parts: Dictionary[GunResource.GunPartSocket, GunPartData] = {}:
	set(v):
		# Clean up old signal connections
		for socket in parts:
			var old_p = parts[socket]
			if old_p and old_p.changed.is_connected(emit_changed):
				old_p.changed.disconnect(emit_changed)
		
		parts = v
		
		# Connect new signal connections
		for socket in parts:
			var new_p = parts[socket]
			if new_p:
				if not new_p.changed.is_connected(emit_changed):
					new_p.changed.connect(emit_changed)
		
		emit_changed()

func get_part(socket: GunResource.GunPartSocket) -> GunPartData:
	return parts.get(socket)

func get_combat_data() -> GunCombatData:
	var data = GunCombatData.new()
	
	for socket in parts:
		var part = parts[socket]
		if not part or not part.combat_data: continue
		var part_combat_data = part.combat_data
		
		data.weight += part_combat_data.weight
		
		# Frame
		if part_combat_data is GunFrameCombatData:
			data.base_damage = part_combat_data.base_damage
			data.fire_rate = part_combat_data.fire_rate
			data.fire_modes = part_combat_data.fire_modes
		
		# Barrel
		elif part_combat_data is GunBarrelCombatData:
			data.bullet_velocity = part_combat_data.bullet_velocity
			data.bullet_spread = part_combat_data.bullet_spread
			data.effective_range = part_combat_data.effective_range
		
		# Mag
		elif part_combat_data is GunMagCombatData:
			data.ammo_capacity = part_combat_data.ammo_capacity
			data.reload_duration = part_combat_data.reload_duration
		
		# Stock
		elif part_combat_data is GunStockCombatData:
			data.recoil_recovery = part_combat_data.recoil_recovery
			data.idle_sway = part_combat_data.idle_sway_amount
		
		# Muzzle
		elif part_combat_data is GunMuzzleCombatData:
			data.muzzle_flash_intensity = part_combat_data.flash_intensity
			data.acoustic_range = part_combat_data.acoustic_range
	
	return data
