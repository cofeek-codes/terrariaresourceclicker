extends PanelContainer

@export var block_texture: Texture2D

@onready var new_block_texture: TextureRect = %NewBlockTexture
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	new_block_texture.texture = block_texture
	animation_player.play("appear")
