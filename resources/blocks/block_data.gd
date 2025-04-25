extends Resource

class_name BlockData

@export var title: String
@export var tier: int = 1
@export var texture: Texture2D
@export var health: int = 3
@export var particles_material: ParticleProcessMaterial
@export var hit_sound: AudioStream = preload("res://assets/audio/sounds/block_hit.wav")
@export var destroy_sound: AudioStream = preload("res://assets/audio/sounds/block_hit.wav")
