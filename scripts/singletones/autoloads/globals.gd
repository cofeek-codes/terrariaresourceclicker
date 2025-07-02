extends Node

var player_data: PlayerData

var default_player_data = load('res://resources/player_data/default_player_data.tres')

func get_player_data() -> PlayerData:
	# @OPTIMIZE: not load every time?
	SaveManager.load_player_data()
	return player_data


func update_income():
	_update_cpc()
	_update_cps()
	
func _update_cpc():
	var cpc_items = player_data.active_items.filter(func(item: ActiveItem): return item.item.effect_type == ShopItem.EffectType.CLICK_INCOME)
	if cpc_items.is_empty():
		player_data.coins_per_click = 0
	else:
		player_data.coins_per_click = 0
		for item: ActiveItem in cpc_items:
			player_data.coins_per_click += item.item.effect_factor * item.amount

func _update_cps():
	var cps_items = player_data.active_items.filter(func(item: ActiveItem): return item.item.effect_type == ShopItem.EffectType.TIME_INCOME)
	if cps_items.is_empty():
		player_data.coins_per_second = 0
	else:
		player_data.coins_per_second = 0
		for item: ActiveItem in cps_items:
			player_data.coins_per_second += item.item.effect_factor * item.amount
