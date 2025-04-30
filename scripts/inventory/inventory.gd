extends Control

signal inventory_open
signal item_added(item: DropItem)

@export var player_data: PlayerData

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pickup_audio_player: AudioStreamPlayer = $PickupAudioPlayer
@onready var inventory_items_container: GridContainer = %InventoryItemsContainer

@onready var inventory_button: Control = $"../InventoryButton"
@onready var pickup_text: Control = $"../PickupText"

var inventory_cell_preload = preload("res://scenes/inventory/inventory_cell.tscn")

func _ready() -> void:
	print(is_open())
	print(player_data.inventory)
	update_inventory_cells()
	 
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

func update_inventory_cells():
	print(player_data.inventory)
	for item: InventoryItem in player_data.inventory:
		var new_inventory_item = inventory_cell_preload.instantiate()
		new_inventory_item.inventory_item_data = item
		inventory_items_container.add_child(new_inventory_item)

func _on_item_added(item: DropItem) -> void:
	print('item added: %s' % item.title)
	pickup_audio_player.play()
	var inventory_item = player_data.get_inventory_item_from_drop(item)
	var item_amount = 1 if inventory_item == null else inventory_item.amount 
	pickup_text.emit_signal('resource_pickedup', item.title, item_amount)
	update_inventory_cells()
