extends Node2D

@export var block_data: BlockData

@onready var sprite: Sprite2D = $BlockArea/Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var block_hit_particles: GPUParticles2D = $BlockHitParticles
@onready var hit_audio_player: AudioStreamPlayer = $HitAudioPlayer

@onready var cursor = $"../Cursor"

const TWEEN_DURATION: float = 0.5
const MAX_PARTICLES: int = 50

var tween: Tween
var current_hp

func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	current_hp = block_data.health
	
	# apply blockdata
	sprite.texture = block_data.texture
	block_hit_particles.process_material = block_data.particles_material
	# apply blockdata

func handle_click():
	print('clicked on block')
	apply_click_visuals()
	apply_block_hit()


func apply_block_hit():
	# @TODO: apply proper damage
	current_hp -= 1
	if current_hp <= 0:
		apply_block_destroy()
	print(current_hp) 
	
	
func apply_block_destroy():
	print('block should be destroyed')

func apply_click_visuals():
	shake()
	emit_particles()
	
func shake():
	#var tween = Utils.safe_create_tween(tween)
	#tween.tween_property(sprite, "scale", Vector2.ONE * 0.5, TWEEN_DURATION)
	#tween.tween_property(sprite, "scale", Vector2.ONE, TWEEN_DURATION)
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
