extends PanelContainer

@export var resorce_texture: Texture2D

@onready var new_resource_texture: TextureRect = %NewResourceTexture
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	new_resource_texture.texture = resorce_texture
	animation_player.play("appear")
