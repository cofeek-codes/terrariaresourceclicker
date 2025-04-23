extends Node2D

@export var player_data: PlayerData

@onready var cursor: Sprite2D = %Cursor
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pickaxe_audio_player: AudioStreamPlayer = $PickaxeAudioPlayer


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	cursor.texture = player_data.get_pickaxe_texture()
	

func handle_click():
	print('click')
	pickaxe_audio_player.pitch_scale = randf_range(0.5, 1.5)
	pickaxe_audio_player.play()
	animation_player.stop()
	if is_cursor_right():
		animation_player.play("click_right")
		animation_player.play_backwards("click_right")
	else:
		animation_player.play("click_left")
		animation_player.play_backwards("click_left")
	
	
func is_cursor_right():
	var screen_center = get_viewport_rect().size.x / 2
	return get_global_mouse_position().x > screen_center
	
func _process(delta: float) -> void:
	cursor.flip_h = is_cursor_right()
	cursor.position = get_global_mouse_position()
	if Input.is_action_just_pressed('click'):
		handle_click()
