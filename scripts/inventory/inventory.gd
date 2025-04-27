extends Control

signal inventory_open
signal inventory_close

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass


func _on_inventory_open() -> void:
	print('inventory_open signal recieved')
	animation_player.play("appear")


func _on_inventory_close() -> void:
	print('inventory_close signal recieved')
	animation_player.play_backwards("appear")
