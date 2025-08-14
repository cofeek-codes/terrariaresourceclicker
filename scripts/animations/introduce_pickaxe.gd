extends Node2D

@export var pickaxe_texture: Texture2D

@onready var player_data = Globals.get_player_data()

@onready var pickaxe_sprite: Sprite2D = %PickaxeSprite
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var new_resources_container: HBoxContainer = %NewResourcesContainer

@onready var game: Node2D = $"/root/Game"

var new_resource_preload = preload("res://scenes/animations/new_resource.tscn")

var blocks: Array[BlockData]

const BLOCKS_FILE_PATH: String = "res://resources/blocks/blocks.json"


func _ready() -> void:
	_load_blocks()

	pickaxe_sprite.texture = pickaxe_texture

	# displaying all blocks of new unlocked tier
	var tier_blocks: Array[BlockData] = get_tier_blocks()

	for block in tier_blocks:
		var new_resource = new_resource_preload.instantiate()
		new_resource.resource_texture = block.drop_item.texture
		new_resource.tooltip = block.drop_item.get_localized_title()
		new_resources_container.add_child(new_resource)
		new_resource.add_to_group("ui_cursor")

	game.handle_mouse_hover_ui_elements()

	self.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	animation_player.play("introduce")
	await animation_player.animation_finished
	animation_player.play("after_idle")


func _load_blocks():
	Globals.load_json_array(BLOCKS_FILE_PATH, blocks)


func get_tier_blocks():
	print_debug(player_data.tier)
	return blocks.filter(func(b: BlockData): return b.tier == player_data.tier)


func _on_continue_button_pressed() -> void:
	for child in new_resources_container.get_children():
		child.emit_signal("dispawn_requested")

	animation_player.play_backwards("introduce_reverse")
	await animation_player.animation_finished
	self.queue_free()
