extends PanelContainer

signal display_item

@export var inventory_item_data: InventoryItem
@export var select_button: Button

@onready var inventory = $"/root/Game/CanvasLayer/GameUI/Inventory"

@onready var inventory_item_image: TextureRect = %InventoryItem
@onready var amount_label: Label = %AmountLabel

@onready var select_audio_player: AudioStreamPlayer = $SelectAudioPlayer


func _ready() -> void:
	self.add_to_group("ui_cursor")
	inventory_item_image.texture = inventory_item_data.item.texture
	amount_label.text = str(inventory_item_data.amount)


func _on_display_item() -> void:
	inventory_item_image.texture = inventory_item_data.item.texture
	amount_label.text = str(inventory_item_data.amount)


func _on_select_button_pressed() -> void:
	select_audio_player.play()
	inventory.emit_signal("item_selected", inventory_item_data)
