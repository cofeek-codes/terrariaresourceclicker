extends Node2D

@onready var player_data = Globals.get_player_data()

@export var pickaxe_texture: Texture2D
@export var block_dict: BlockDictionary

@onready var pickaxe_sprite: Sprite2D = %PickaxeSprite
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var new_blocks_container: HBoxContainer = %NewBlocksContainer

var new_block_preload = preload("res://scenes/animations/new_block.tscn")

func get_tier_blocks():
	return block_dict.blocks.filter((func(b: BlockData): return b.tier == player_data.tier))

func _ready() -> void:
	pickaxe_sprite.texture = pickaxe_texture
	
	# displaying all blocks of new unlocked tier 
	var tier_blocks: Array[BlockData] = get_tier_blocks()
	
	for block in tier_blocks:
		var new_block = new_block_preload.instantiate()
		new_block.block_texture = block.texture
		new_blocks_container.add_child(new_block)
	 
	self.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	animation_player.play("introduce")
	
	await animation_player.animation_finished
	animation_player.play("after_idle")
