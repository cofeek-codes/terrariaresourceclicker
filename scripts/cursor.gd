extends Node2D

enum CursorMode {
	UI,
	GAME,
}

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var cursor_area: Area2D = $CursorArea
@onready var cursor_sprite: Sprite2D = $CursorArea/CursorSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioPlayer

@onready var block: Node2D = $"../Block"
@onready var block_area: Area2D = $"../Block/BlockArea"

var ui_cursor_icon = preload("res://assets/icons/ui_cursor_icon.png")

var mode: CursorMode = CursorMode.GAME


func _ready() -> void:
	cursor_sprite.texture = player_data.get_pickaxe_texture()


func _process(delta: float) -> void:
	if self.mode == CursorMode.GAME:
		cursor_sprite.flip_h = is_cursor_right()
	else:
		cursor_sprite.flip_h = false
		
	self.position = get_global_mouse_position()


func is_cursor_right():
	var screen_center = get_viewport_rect().size.x / 2
	return get_global_mouse_position().x > screen_center
	

func show_ui_cursor():
	self.mode = CursorMode.UI
	cursor_sprite.texture = ui_cursor_icon
	cursor_sprite.scale = Vector2(0.5, 0.5)

func show_game_cursor():
	self.mode = CursorMode.GAME
	cursor_sprite.texture = player_data.get_pickaxe_texture()
	cursor_sprite.scale = Vector2.ONE



func handle_click():
	print('click')
	
	if self.mode == CursorMode.GAME:
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
	
	for mob in get_tree().get_nodes_in_group('mobs'):
		if mob is Area2D:
			if cursor_area in mob.get_overlapping_areas():
				mob.handle_click()
