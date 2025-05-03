extends Control

@export var player_data: PlayerData

@onready var coin_label: Label = %CoinLabel


func _process(delta: float) -> void:
	coin_label.text = str(player_data.coins)
