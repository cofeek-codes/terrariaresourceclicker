extends Node2D

@export var player_data: PlayerData

# cursor
@onready var cursor: Node2D = %Cursor
@onready var cursor_area: Area2D = %Cursor/CursorArea
@onready var cursor_sprite: Sprite2D = %Cursor/CursorArea/CursorSprite
@onready var cursor_animation_player: AnimationPlayer = %Cursor/CursorAnimationPlayer
@onready var cursor_audio_player: AudioStreamPlayer = %Cursor/CursorAudioPlayer

# cursor


@onready var block: Node2D = %Block
@onready var block_area: Area2D = block.get_node('BlockArea')



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	cursor_sprite.texture = player_data.get_pickaxe_texture()
	block.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	

func handle_click():
	print('click')
	cursor_audio_player.pitch_scale = randf_range(0.5, 1.5)
	cursor_audio_player.play()
	
	cursor_animation_player.stop()
	if is_cursor_right():
		cursor_animation_player.play("click_right")
		cursor_animation_player.play_backwards("click_right")
	else:
		cursor_animation_player.play("click_left")
		cursor_animation_player.play_backwards("click_left")
		
# click on block
	if cursor_area in block_area.get_overlapping_areas():
		block.handle_click()
	
func is_cursor_right():
	var screen_center = get_viewport_rect().size.x / 2
	return get_global_mouse_position().x > screen_center
	
func _process(delta: float) -> void:
	cursor_sprite.flip_h = is_cursor_right()
	cursor.position = get_global_mouse_position()
	if Input.is_action_just_pressed('click'):
		handle_click()
