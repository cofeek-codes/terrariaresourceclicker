extends Node2D

var tween: Tween

@onready var sprite: Sprite2D = $BlockArea/Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var cursor = $"../Cursor"

const TWEEN_DURATION: float = 0.5


func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)

func handle_click():
	print('clicked on block')
	apply_click_visuals()


func apply_click_visuals():
	shake()
	
func shake():
	#var tween = Utils.safe_create_tween(tween)
	#tween.tween_property(sprite, "scale", Vector2.ONE * 0.5, TWEEN_DURATION)
	#tween.tween_property(sprite, "scale", Vector2.ONE, TWEEN_DURATION)
	animation_player.stop()
	if cursor.is_cursor_right():
		animation_player.play("hit_right")
		animation_player.play_backwards("hit_right")
	else:
		animation_player.play("hit_left")
		animation_player.play_backwards("hit_left")
	
