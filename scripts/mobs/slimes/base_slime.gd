extends Mob

class_name MobSlime


func _ready() -> void:
	super._ready()

	mob_data = mob_data as SlimeMobData

	if mob_data.use_color:
		sprite_animation_player.self_modulate = mob_data.color
		mob_hit_particles.process_material.color = mob_data.color

	print(mob_data.to_dict())
