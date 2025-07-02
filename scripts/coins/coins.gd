extends Control

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var coin_label: Label = %CoinLabel
@onready var cps_label: Label = %CPSLabel
@onready var cpc_label: Label = %CPCLabel

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	coin_label.text = Utils.abbreviate_number(player_data.coins)
	cps_label.text = Utils.abbreviate_number(player_data.coins_per_second)
	cpc_label.text = Utils.abbreviate_number(player_data.coins_per_click)

func _on_cps_timer_timeout() -> void:
	player_data.coins += player_data.coins_per_second
