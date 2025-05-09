extends Control

@export var selected_item: InventoryItem

@onready var player_data: PlayerData = Globals.get_player_data()

# @onready var sell_one_button: Button = %SellOneButton
# @onready var sell_all_button: Button = %SellAllButton

func _ready() -> void:
	self.hide()


func _on_sell_one_button_pressed() -> void:
	pass # Replace with function body.


func _on_sell_all_button_pressed() -> void:
	pass # Replace with function body.
