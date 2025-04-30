extends PanelContainer

@export var inventory_item_data: InventoryItem

@onready var inventory_item_image: TextureRect = %InventoryItem
@onready var amount_label: Label = %AmountLabel



func _ready() -> void:
	inventory_item_image.texture = inventory_item_data.item.texture
	amount_label.text = str(inventory_item_data.amount)
