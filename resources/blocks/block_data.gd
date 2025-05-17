extends Resource

class_name BlockData

@export var title: String
@export var tier: int = 1
@export var texture: Texture2D
@export var health: int = 3
@export var particles_material: ParticleProcessMaterial
@export var hit_sound: AudioStream
@export var destroy_sound: AudioStream
@export var drop_item: DropItem
