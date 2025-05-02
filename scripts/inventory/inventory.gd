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
	init_inventory_cells()
	 
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

func init_inventory_cells():
	print(player_data.inventory)
	for item: InventoryItem in player_data.inventory:
		var new_inventory_item = inventory_cell_preload.instantiate()
		new_inventory_item.inventory_item_data = item
		inventory_items_container.add_child(new_inventory_item)

func add_item_to_inventory(item: DropItem):
	var new_item = InventoryItem.new()
	new_item.item = item
	new_item.amount = 1
	var existing_item_idx = player_data.inventory.find_custom((func(i: InventoryItem): return i.item == item).bind())
	if existing_item_idx != -1:
		var existing_item = player_data.inventory[existing_item_idx]
		existing_item.amount += 1
		pickup_text.emit_signal('resource_pickedup', existing_item.item.title, existing_item.amount)
	else:
		player_data.inventory.push_back(new_item)
		pickup_text.emit_signal('resource_pickedup', new_item.item.title, 1)
		
	print('player_data.inventory in add_item_to_inventory')
	print(player_data.inventory)
	add_or_update_inventory_cell(existing_item_idx)

func add_or_update_inventory_cell(update_index: int):
	if update_index == -1:
		var new_cell = inventory_cell_preload.instantiate()
		new_cell.inventory_item_data = player_data.inventory[-1]
		inventory_items_container.add_child(new_cell)
		new_cell.emit_signal('display_item')
	else:
		var cell_to_update = inventory_items_container.get_child(update_index)
		cell_to_update.inventory_item_data = player_data.inventory[update_index]
		cell_to_update.emit_signal('display_item')
		

func _on_item_added(item: DropItem) -> void:
	print('item added: %s' % item.title)
	pickup_audio_player.play()
	var inventory_item = player_data.get_inventory_item_from_drop(item)
	add_item_to_inventory(item)
