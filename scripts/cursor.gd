extends Node2D

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var cursor_area: Area2D = $CursorArea
@onready var cursor_sprite: Sprite2D = $CursorArea/CursorSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioPlayer

@onready var block: Node2D = $"../Block"
@onready var block_area: Area2D = $"../Block/BlockArea"

func _ready() -> void:
	cursor_sprite.texture = player_data.get_pickaxe_texture()

func _process(delta: float) -> void:
	cursor_sprite.flip_h = is_cursor_right()
	self.position = get_global_mouse_position()


func is_cursor_right():
	var screen_center = get_viewport_rect().size.x / 2
	return get_global_mouse_position().x > screen_center
	

func handle_click():
	print('click')
	audio_player.pitch_scale = randf_range(0.5, 1.5)
	audio_player.play()
	
	animation_player.stop()
	if is_cursor_right():
		animation_player.play("click_right")
		animation_player.play_backwards("click_right")
	else:
		animation_player.play("click_left")
		animation_player.play_backwards("click_left")
		
# click on block
	if cursor_area in block_area.get_overlapping_areas():
		block.handle_click()
