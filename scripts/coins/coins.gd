extends Control

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var coin_label: Label = %CoinLabel
@onready var cps_label: Label = %CPSLabel
@onready var cpc_label: Label = %CPCLabel

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	coin_label.text = player_data.coins.toAA(true)
	cps_label.text = player_data.coins_per_second.toAA(true)
	cpc_label.text = player_data.coins_per_click.toAA(true)

func _on_cps_timer_timeout() -> void:
	player_data.coins.plusEquals(player_data.coins_per_second)
