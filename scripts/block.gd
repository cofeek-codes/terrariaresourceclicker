extends Node2D

# leave export for debugging
#@export var block_data: BlockData 
@export var player_data: PlayerData 
@export var block_dict: BlockDictionary

@onready var sprite: Sprite2D = $BlockArea/Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var block_hit_particles: GPUParticles2D = $BlockHitParticles
@onready var hit_audio_player: AudioStreamPlayer = $HitAudioPlayer
@onready var destroy_audio_player: AudioStreamPlayer = $DestroyAudioPlayer

@onready var cursor = $"../Cursor"
@onready var pickup_text = $"../GameUI/PickupText"
@onready var game = $"/root/Game"

const TWEEN_DURATION: float = 0.5
const MAX_PARTICLES: int = 50

var tween: Tween
var current_hp: int

func _ready() -> void:
	var block_data: BlockData = get_random_block()
	load_block_data(block_data)
	self.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	animation_player.play_backwards("disappear")
	
	
func handle_click():
	print('clicked on block')
	apply_click_visuals()
	block_hit()


func get_random_block() -> BlockData:
	var player_tier = player_data.tier
	var player_tier_blocks: Array[BlockData] = block_dict.blocks.filter(func(b:BlockData): return b.tier <= player_tier)
	print(player_tier_blocks.map(func(b:BlockData): return b.title))
	var res: BlockData = player_tier_blocks.pick_random()
	print(res.title)
	return res

func load_block_data(bd: BlockData):
	# apply blockdata
	sprite.texture = bd.texture
	block_hit_particles.process_material = bd.particles_material
	current_hp = bd.health
	hit_audio_player.stream = bd.hit_sound
	destroy_audio_player.stream = bd.destroy_sound
	
	# apply blockdata

func block_hit():
	# @TODO: apply proper damage
	current_hp -= 1
	if current_hp <= 0:
		block_destroy()
	print(current_hp) 
	
	
func block_destroy():
	print('block should be destroyed')
	var new_block_data: BlockData = get_random_block()
	animation_player.play('disappear')
	pickup_text.emit_signal('resource_pickedup', 'wood')
	load_block_data(new_block_data)
	animation_player.play('RESET')
	await animation_player.animation_finished
	animation_player.play_backwards('disappear')

func apply_click_visuals():
	shake()
	emit_particles()
	
func shake():
	hit_audio_player.pitch_scale = randf_range(0.8, 1)
	hit_audio_player.play()
	animation_player.stop()
	if cursor.is_cursor_right():
		animation_player.play("hit_right")
		animation_player.play_backwards("hit_right")
	else:
		animation_player.play("hit_left")
		animation_player.play_backwards("hit_left")
	

func emit_particles():
	if get_tree().get_node_count_in_group('particles') < MAX_PARTICLES:	
		var particles: GPUParticles2D = block_hit_particles.duplicate()
		self.add_to_group('particles')
		self.add_child(particles)
		particles.position = to_local(get_global_mouse_position())
		particles.process_material.direction.x = 1 if cursor.is_cursor_right() else -1
		particles.restart()
		await particles.finished
		particles.queue_free()
	else:
		print('too many block particles')
