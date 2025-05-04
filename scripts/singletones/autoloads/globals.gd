extends Node

var player_data: PlayerData

var default_player_data = load('res://resources/player_data/default_player_data.tres')

func get_player_data() -> PlayerData:
	# @OPTIMIZE: not load every time?
	SaveManager.load_player_data()
	return player_data
