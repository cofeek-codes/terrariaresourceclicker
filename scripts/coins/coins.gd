extends Control

@export var player_data: PlayerData

@onready var coin_label: Label = %CoinLabel
@onready var cps_label: Label = %CPSLabel

func _ready() -> void:
	coin_label.text = str(player_data.coins)
	cps_label.text = str(player_data.coins_per_second)


func _process(delta: float) -> void:
	coin_label.text = str(player_data.coins)
	cps_label.text = str(player_data.coins_per_second)


func _on_cps_timer_timeout() -> void:
	player_data.coins += player_data.coins_per_second
