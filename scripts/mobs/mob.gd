extends CharacterBody2D

class_name Mob

@export var mob_data: MobData

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var sprite_animation_player: AnimatedSprite2D = $SpriteAnimationPlayer
@onready var health_bar: ProgressBar = $HealthBar
@onready var jump_cooldown_timer: Timer = $JumpCooldownTimer

var max_hp: int
var current_hp: int
var sprite_size: Vector2


func _ready() -> void:
	print('Mob base scene initialized in _ready()')
	print('Mob %s ai_type %s' % [mob_data.name, mob_data.AIType.keys()[mob_data.ai_type]])
	max_hp = mob_data.health
	current_hp = max_hp
	health_bar.max_value = max_hp
	health_bar.value = current_hp
	health_bar.self_modulate = Color.TRANSPARENT
	
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
	print('clicked on mob %s' % mob_data.name)
	_take_damage(player_data.calculate_damage())


func _take_damage(damage: int):
	current_hp -= damage
	_update_healthbar()
	print('mob %s recieved damage: %d, remaining hp: %d' % [mob_data.name, damage, current_hp])
	if current_hp <= 0:
		_die()


func _die():
	print('mob %s should die' % mob_data.name)
	sprite_animation_player.play("die")



func _update_healthbar():
	if health_bar.value == max_hp:
		var modulate_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		modulate_tween.tween_property(health_bar, "self_modulate", Color.WHITE, 0.5)
		await get_tree().create_timer(0.3).timeout
	var value_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	value_tween.tween_property(health_bar, "value", current_hp, 0.3)
