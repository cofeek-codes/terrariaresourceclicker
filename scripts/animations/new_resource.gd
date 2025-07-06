extends PanelContainer

signal dispawn_requested

@export var resource_texture: Texture2D

@onready var new_resource_texture: TextureRect = %NewResourceTexture
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	new_resource_texture.texture = resource_texture
	animation_player.play("appear")


func _on_dispawn_requested() -> void:
	animation_player.play_backwards("appear")
	await animation_player.animation_finished
	self.queue_free()
