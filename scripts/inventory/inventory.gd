extends Control

signal inventory_open
signal item_pickup(item: DropItem)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pickup_audio_player: AudioStreamPlayer = $PickupAudioPlayer

@onready var inventory_button: Control = $"../InventoryButton"


func _ready() -> void:
	print(is_open())
	# sometimes initial position of Inventory node can be wierd
	# so better do it like this
	 
	self.position.x = -self.size.x


func _on_inventory_open() -> void:
	print('inventory_open signal recieved')
	animation_player.play("appear")


func close_inventory() -> void:
	print('inventory_close signal recieved')
	animation_player.play_backwards("appear")
	inventory_button.emit_signal('inventory_close')

func is_open(): return self.position == Vector2.ZERO


func _on_close_button_pressed() -> void:
	close_inventory()


func _on_item_pickup(item: DropItem) -> void:
	print('item pickup: %s' % item.title)
	pickup_audio_player.play()
