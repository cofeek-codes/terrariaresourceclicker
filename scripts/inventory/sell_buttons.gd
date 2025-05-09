extends Control

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var sell_one_button: Button = %SellOneButton
@onready var sell_all_button: Button = %SellAllButton

func _ready() -> void:
	self.hide()
