extends Control

signal inventory_open

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var inventory_button: Control = $"../InventoryButton"

func _ready() -> void:
	pass


func _on_inventory_open() -> void:
	print('inventory_open signal recieved')
	animation_player.play("appear")


func close_inventory() -> void:
	print('inventory_close signal recieved')
	animation_player.play_backwards("appear")
	inventory_button.emit_signal('inventory_close')


func _on_close_button_pressed() -> void:
	close_inventory()
