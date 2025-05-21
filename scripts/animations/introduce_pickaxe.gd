extends Node2D

@onready var player_data = Globals.get_player_data()

@export var pickaxe_texture: Texture2D
@export var block_dict: BlockDictionary

@onready var pickaxe_sprite: Sprite2D = %PickaxeSprite
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var new_resources_container: HBoxContainer = %NewResourcesContainer


var new_resource_preload = preload("res://scenes/animations/new_resource.tscn")

func get_tier_blocks():
	return block_dict.blocks.filter((func(b: BlockData): return b.tier == player_data.tier))

func _ready() -> void:
	pickaxe_sprite.texture = pickaxe_texture
	
	# displaying all blocks of new unlocked tier 
	var tier_blocks: Array[BlockData] = get_tier_blocks()
	
	for block in tier_blocks:
		var new_resource = new_resource_preload.instantiate()
		new_resource.resource_texture = block.drop_item.texture
		new_resources_container.add_child(new_resource)
	 
	self.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	animation_player.play("introduce")
	
	await animation_player.animation_finished
	animation_player.play("after_idle")
