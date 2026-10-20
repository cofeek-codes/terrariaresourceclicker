extends Control

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var coin_label: Label = %CoinLabel
@onready var cps_label: Label = %CPSLabel
@onready var cpc_label: Label = %CPCLabel


const UPDATE_INTERVAL: float = 0.1

var _update_accumulator: float = 0.0
var _coins_text: String
var _cps_text: String
var _cpc_text: String


func _ready() -> void:
	_update_labels(true)


func _process(delta: float) -> void:
	_update_accumulator += delta
	if _update_accumulator < UPDATE_INTERVAL:
		return
	_update_accumulator = 0.0
	_update_labels()


func _update_labels(force: bool = false) -> void:
	# Big number string formatting is expensive, so we throttle it
	# and only update labels when the text actually changes.
	var coins_text = player_data.coins.toAA(true)
	var cps_text = player_data.coins_per_second.toAA(true)
	var cpc_text = player_data.coins_per_click.toAA(true)

	if force or coins_text != _coins_text:
		coin_label.text = coins_text
		_coins_text = coins_text

	if force or cps_text != _cps_text:
		cps_label.text = cps_text
		_cps_text = cps_text

	if force or cpc_text != _cpc_text:
		cpc_label.text = cpc_text
		_cpc_text = cpc_text


func _on_cps_timer_timeout() -> void:
	player_data.coins.plusEquals(player_data.coins_per_second)
