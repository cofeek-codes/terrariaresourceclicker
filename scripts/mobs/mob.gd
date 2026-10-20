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
@onready var mob_death_particles: GPUParticles2D = $MobDeathParticles
@onready var direction_change_timer: Timer = $DirectionChangeTimer

@onready var cursor: Node2D = $"/root/Game/CanvasLayer/Cursor"

var max_hp: int
var current_hp: int
var sprite_size: Vector2
var direction: int

var is_dead: bool = false
var _current_animation: StringName = &""

var drop_item_scene_preload = preload("res://scenes/drop_item.tscn")

const KNOCKBACK_VELOCITY_MULTIPLYER: float = 1.1


func _ready() -> void:
	max_hp = mob_data.health
	current_hp = max_hp
	health_bar.max_value = max_hp
	health_bar.value = current_hp
	health_bar.self_modulate = Color.TRANSPARENT
	hit_audio_player.stream = mob_data.hit_sound
	death_audio_player.stream = mob_data.death_sound


func _physics_process(delta: float) -> void:
	_move(delta)


func _play_animation(anim: StringName) -> void:
	# Avoid re-calling play() with the same animation every physics frame.
	if _current_animation == anim and sprite_animation_player.is_playing():
		return
	_current_animation = anim
	sprite_animation_player.play(anim)


func _move(delta: float):
	if !is_on_floor() && mob_data.ai_type != mob_data.AIType.FLYING:
		velocity += get_gravity() * delta
		_play_animation(&"fall")
	if is_on_wall():
		_change_direction(true)
	match mob_data.ai_type:
		mob_data.AIType.JUMPING:
			_jump(delta)
		mob_data.AIType.FLYING:
			_play_animation(&"move")
			sprite_animation_player.flip_h = direction > 0
			velocity.x += mob_data.speed * direction
			velocity.y += mob_data.speed * direction
		mob_data.AIType.WALKING:
			if direction == 0:
				_play_animation(&"idle")
				velocity.x = 0
			else:
				_play_animation(&"move")
				sprite_animation_player.flip_h = direction > 0
				velocity.x = mob_data.speed * direction

	move_and_slide()


func _jump(delta: float):
	if is_on_floor():
		if jump_cooldown_timer.is_stopped():
			_current_animation = &""
			# not all mobs will have dedicated jump animation
			if sprite_animation_player.sprite_frames.has_animation("jump"):
				_play_animation(&"jump")
			velocity.x = mob_data.speed * direction
			velocity.y = -abs(mob_data.jump_force)
			jump_cooldown_timer.wait_time = randf_range(1, 1.5)
			jump_cooldown_timer.start()
		else:
			velocity.x = 0
			_play_animation(&"idle")


func handle_click():
	if !is_dead:
		hit_audio_player.play()
		_apply_knockback()
		_emit_particles()
		_take_damage(player_data.calculate_damage())


func _emit_particles():
	if get_tree().get_node_count_in_group("particles") < Constants.MAX_PARTICLES:
		var particles: GPUParticles2D = mob_hit_particles.duplicate()
		self.add_child(particles)
		particles.add_to_group("particles")
		particles.position = to_local(get_global_mouse_position())
		particles.process_material.direction.x = 1 if cursor.is_cursor_right() else -1
		particles.restart()
		await particles.finished
		particles.queue_free()


func _apply_knockback():
	var direction = 1 if !cursor.is_cursor_right() else -1
	velocity.x = (mob_data.speed * KNOCKBACK_VELOCITY_MULTIPLYER) * direction
	velocity.y = -abs(mob_data.jump_force * KNOCKBACK_VELOCITY_MULTIPLYER)


func _take_damage(damage: int):
	current_hp -= damage
	_update_healthbar()
	if current_hp <= 0:
		_die()


func _die():
	is_dead = true
	_play_animation(&"die")
	mob_death_particles.restart()
	death_audio_player.play()
	health_bar.visible = false
	player_data.coins.plusEquals(mob_data.drop_coins)
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
	for item in mob_data.drop: # keys are DropItem resources
		var drop_range: Vector2i = mob_data.drop[item]
		for i in randi_range(drop_range.x, drop_range.y):
			var drop_item = drop_item_scene_preload.instantiate()
			drop_item.position = self.position
			drop_item.drop_item_data = item
			self.get_parent().add_child(drop_item)


func _on_direction_change_timer_timeout() -> void:
	_change_direction()
	direction_change_timer.wait_time = randf_range(3, 5)
	direction_change_timer.start()


func _change_direction(reverse: bool = false):
	if reverse:
		direction = -direction

	direction = randi_range(-1, 1)
