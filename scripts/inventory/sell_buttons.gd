extends Control

signal get_inventory_cells_container(cells_container_node: GridContainer)

@export var selected_item: InventoryItem

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var sell_audio_player: AudioStreamPlayer = %SellAudioPlayer

@onready var pickup_text: Control = $"/root/Game/CanvasLayer/GameUI/PickupText"

var inventory_cells_container: GridContainer


func _ready() -> void:
	self.hide()


func _on_sell_one_button_pressed() -> void:
	print('sell_one_button_pressed')
	print('before: %s (%d)' % [selected_item.item.title, selected_item.amount])
	sell_audio_player.play()
	player_data.coins += selected_item.item.price
	pickup_text.emit_signal('item_sold', selected_item.item.title, 1, selected_item.item.price)
	var selected_item_idx = player_data.inventory.find(selected_item)
	var inventory_cell_idx = inventory_cells_container.get_children().find_custom((func(c: PanelContainer): return c.inventory_item_data == selected_item).bind())
	var inventory_cell_button: Button = inventory_cells_container.get_child(inventory_cell_idx).select_button
	inventory_cell_button.grab_focus()
	
	if player_data.inventory[selected_item_idx].amount == 1:
		player_data.inventory.remove_at(selected_item_idx)
		inventory_cells_container.get_child(inventory_cell_idx).queue_free()
		self.hide()
	else:
		player_data.inventory[selected_item_idx].amount -= 1
		inventory_cells_container.get_child(inventory_cell_idx).emit_signal('display_item')	
	
	print('after: %s (%d)' % [selected_item.item.title, selected_item.amount])
	
func _on_sell_all_button_pressed() -> void:
	print('sell_all_button_pressed')
	print('%s (%d)' % [selected_item.item.title, selected_item.amount])
	sell_audio_player.play()
	var total_price = selected_item.item.price * selected_item.amount
	player_data.coins += total_price
	pickup_text.emit_signal('item_sold', selected_item.item.title, selected_item.amount, total_price)
	var selected_item_idx = player_data.inventory.find(selected_item)
	var inventory_cell_idx = inventory_cells_container.get_children().find_custom((func(c: PanelContainer): return c.inventory_item_data == selected_item).bind())
	player_data.inventory.remove_at(selected_item_idx)
	inventory_cells_container.get_child(inventory_cell_idx).queue_free()
	self.hide()


func _on_get_inventory_cells_container(cells_container_node: GridContainer) -> void:
	self.inventory_cells_container = cells_container_node
