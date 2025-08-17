extends Resource

class_name BlockData

@export var title: String
@export var texture: Texture2D
@export var tier: int = 1
@export var particles_material: ParticleProcessMaterial
@export var hit_sound: AudioStream
@export var destroy_sound: AudioStream
@export var drop_item: DropItem


func calculate_health(player_tier: int):
	var hp: int

	if tier == player_tier:
		hp = 3
	elif tier == player_tier - 1:
		hp = 2
	else:
		hp = 1

	return hp
