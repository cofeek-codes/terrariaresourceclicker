extends CharacterBody2D

class_name Mob

@export var mob_data: MobData

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var sprite_animation_player: AnimatedSprite2D = $SpriteAnimationPlayer
@onready var health_bar: ProgressBar = $HealthBar
@onready var jump_cooldown_timer: Timer = $JumpCooldownTimer
@onready var hit_audio_player: AudioStreamPlayer = $HitAudioPlayer
@onready var death_audio_player: AudioStreamPlayer = $DeathAudioPlayer
@onready var mob_hit_particles: GPUParticles2D = $MobHitParticles

@onready var cursor: Node2D = $"/root/Game/CanvasLayer/Cursor"

var max_hp: int
var current_hp: int
var sprite_size: Vector2

var is_dead: bool = false

const KNOCKBACK_VELOCITY_MULTIPLYER: float = 1.1

var drop_item_scene_preload = preload("res://scenes/drop_item.tscn")


func _ready() -> void:
	print('Mob base scene initialized in _ready()')
	print('Mob %s ai_type %s' % [mob_data.name, mob_data.AIType.keys()[mob_data.ai_type]])
	max_hp = mob_data.health
	current_hp = max_hp
	health_bar.max_value = max_hp
	health_bar.value = current_hp
	health_bar.self_modulate = Color.TRANSPARENT
	hit_audio_player.stream = mob_data.hit_sound
	death_audio_player.stream = mob_data.death_sound
	
	jump_cooldown_timer.start()


func _physics_process(delta: float) -> void:
	_move(delta)


func _move(delta: float):
	if !is_on_floor():
		velocity += get_gravity() * delta
		sprite_animation_player.play('fall')
		
	match mob_data.ai_type:
		mob_data.AIType.JUMPING:
			_jump(delta)
		_:
			pass
	
	move_and_slide()
	
	
	
func _jump(delta: float):
	var direction = randi_range(-1, 1)
	if is_on_floor():
		if jump_cooldown_timer.is_stopped():
			# not all mobs will have dedicated jump animation
			if sprite_animation_player.sprite_frames.has_animation('jump'):
				sprite_animation_player.play('jump')
			velocity.x = mob_data.speed * direction
			velocity.y = -abs(mob_data.jump_force)
			jump_cooldown_timer.wait_time = randf_range(1, 1.5)
			jump_cooldown_timer.start()
		else:
			velocity.x = 0
			sprite_animation_player.play('idle')
		
	
	
func handle_click():
	if !is_dead:
		print('clicked on mob %s' % mob_data.name)
		hit_audio_player.play()
		_apply_knockback()
		_emit_particles()
		_take_damage(player_data.calculate_damage())


func _emit_particles():
	if get_tree().get_node_count_in_group('particles') < Constants.MAX_PARTICLES:
		var particles: GPUParticles2D = mob_hit_particles.duplicate()
		self.add_child(particles)
		particles.add_to_group('particles')
		print("current particles amount: %d" % get_tree().get_node_count_in_group('particles'))
		particles.position = to_local(get_global_mouse_position())
		particles.process_material.direction.x = 1 if cursor.is_cursor_right() else -1
		particles.restart()
		await particles.finished
		particles.queue_free()
	else:
		print('too many mob particles')



func _apply_knockback():
	var direction = 1 if !cursor.is_cursor_right() else -1
	velocity.x = (mob_data.speed * KNOCKBACK_VELOCITY_MULTIPLYER) * direction
	velocity.y = -abs(mob_data.jump_force * KNOCKBACK_VELOCITY_MULTIPLYER)
	print("%d | %d" % [velocity.x, direction])


func _take_damage(damage: int):
	current_hp -= damage
	_update_healthbar()
	print('mob %s recieved damage: %d, remaining hp: %d' % [mob_data.name, damage, current_hp])
	if current_hp <= 0:
		_die()


func _die():
	print('mob %s should die' % mob_data.name)
	is_dead = true
	sprite_animation_player.play("die")
	death_audio_player.play()
	health_bar.visible = false
	_spawn_drop()
	var scale_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(sprite_animation_player, "scale", Vector2.ZERO, 0.3)
	await get_tree().create_timer(1).timeout
	self.queue_free()


func _update_healthbar():
	if health_bar.value == max_hp:
		var modulate_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		modulate_tween.tween_property(health_bar, "self_modulate", Color.WHITE, 0.5)
		await get_tree().create_timer(0.3).timeout
	var value_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	value_tween.tween_property(health_bar, "value", current_hp, 0.3)


func _spawn_drop():
	print('should spawn drop')
	print(mob_data.drop)
	for item in mob_data.drop:
		print(item)
		print(mob_data.drop[item])
		for i in randi_range(mob_data.drop[item].x, mob_data.drop[item].y):
			print('drop i - %d' % i)
			var drop_item = drop_item_scene_preload.instantiate()
			drop_item.position = self.position
			drop_item.drop_item_data = item
			self.get_parent().add_child(drop_item)
