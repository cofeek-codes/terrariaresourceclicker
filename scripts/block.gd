extends Node2D


func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)

func handle_click():
	print('clicked on block')
