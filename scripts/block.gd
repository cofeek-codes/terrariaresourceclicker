extends Node2D

@export var current_block_data: BlockData

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var sprite: Sprite2D = $BlockArea/Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var block_hit_particles: GPUParticles2D = $BlockHitParticles
@onready var hit_audio_player: AudioStreamPlayer = $HitAudioPlayer
@onready var destroy_audio_player: AudioStreamPlayer = $DestroyAudioPlayer

@onready var cursor = $"../Cursor"
@onready var pickup_text = $"../GameUI/PickupText"
@onready var game = $"/root/Game"

var drop_item_scene_preload = preload("res://scenes/drop_item.tscn")

var tween: Tween
var current_hp: int
var blocks: Array[BlockData]

const TWEEN_DURATION: float = 0.5
const BLOCKS_FILE_PATH: String = "res://resources/blocks/blocks.json"


func _ready() -> void:
	_load_blocks()
	var block_data: BlockData = get_random_block()
	load_block_data(block_data)
	self.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	animation_player.play_backwards("disappear")


func _load_blocks():
	Globals.load_json_array(BLOCKS_FILE_PATH, blocks)


func handle_click():
	print("clicked on block")
	apply_click_visuals()
	block_hit()


func get_random_block() -> BlockData:
	var player_tier = player_data.tier
	var player_tier_blocks: Array[BlockData] = blocks.filter(func(b: BlockData): return b.tier <= player_tier)
	print("player tier: %d " % player_tier)
	print("player tier blocks")
	print(player_tier_blocks.map(func(b: BlockData): return b.title))
	var res: BlockData = player_tier_blocks.pick_random()
	print(res.title)
	return res


func load_block_data(bd: BlockData):
	# set blockdata
	current_block_data = bd
	# apply blockdata
	sprite.texture = current_block_data.texture
	block_hit_particles.process_material = current_block_data.particles_material
	current_hp = current_block_data.calculate_health(player_data.tier)
	print("current block hp: " + str(current_block_data.calculate_health(player_data.tier)))
	hit_audio_player.stream = current_block_data.hit_sound
	destroy_audio_player.stream = current_block_data.destroy_sound

	# apply blockdata


func block_hit():
	# we use `1` as damage here because block takes maximum 3 hits to be destroyed
	current_hp -= 1
	if current_hp <= 0:
		block_destroy()
	print(current_hp)


func block_destroy():
	print("block should be destroyed")
	destroy_audio_player.play()
	await destroy_audio_player.finished
	var new_block_data: BlockData = get_random_block()
	animation_player.play("disappear")
	var drop_item = drop_item_scene_preload.instantiate()
	drop_item.position = self.position
	drop_item.drop_item_data = current_block_data.drop_item
	get_parent().add_child(drop_item)
	player_data.coins.plusEquals(player_data.coins_per_click)
	load_block_data(new_block_data)
	animation_player.play("RESET")
	await animation_player.animation_finished
	animation_player.play_backwards("disappear")


func apply_click_visuals():
	shake()
	emit_particles()


func shake():
	hit_audio_player.pitch_scale = randf_range(0.5, 1.5)
	hit_audio_player.play()
	animation_player.stop()
	if cursor.is_cursor_right():
		animation_player.play("hit_right")
		animation_player.play_backwards("hit_right")
	else:
		animation_player.play("hit_left")
		animation_player.play_backwards("hit_left")


func emit_particles():
	if get_tree().get_node_count_in_group("particles") < Constants.MAX_PARTICLES:
		var particles: GPUParticles2D = block_hit_particles.duplicate()
		self.add_child(particles)
		particles.add_to_group("particles")
		print("current particles amount: %d" % get_tree().get_node_count_in_group("particles"))
		particles.position = to_local(get_global_mouse_position())
		particles.process_material.direction.x = 1 if cursor.is_cursor_right() else -1
		particles.restart()
		await particles.finished
		particles.queue_free()
	else:
		print("too many block particles")
