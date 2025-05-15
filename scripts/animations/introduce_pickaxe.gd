extends Node2D

@export var pickaxe_texture: Texture2D

@onready var pickaxe_sprite: Sprite2D = $PickaxeSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	pickaxe_sprite.texture = pickaxe_texture
	self.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	animation_player.play("introduce")
