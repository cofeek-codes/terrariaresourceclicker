extends Node

enum Biome {
	FOREST,
	WINTER,
	DESERT,
}

var player_data: PlayerData = load("res://resources/player_data/default_player_data.tres")

var default_player_data = load("res://resources/player_data/default_player_data.tres")
var default_settings = load("res://resources/settings/default_settings.tres")


func get_player_data() -> PlayerData:
	return player_data


func update_income():
	_update_cpc()
	_update_cps()


func _update_cpc():
	var cpc_items = player_data.active_items.filter(func(item: ActiveItem): return item.item.effect_type == ShopItem.EffectType.CLICK_INCOME)
	if cpc_items.is_empty():
		player_data.coins_per_click = Big.new(0)
	else:
		player_data.coins_per_click = Big.new(0)
		for item: ActiveItem in cpc_items:
			player_data.coins_per_click.plusEquals(item.item.effect_factor * item.amount)


func _update_cps():
	var cps_items = player_data.active_items.filter(func(item: ActiveItem): return item.item.effect_type == ShopItem.EffectType.TIME_INCOME)
	if cps_items.is_empty():
		player_data.coins_per_second = Big.new(0)
	else:
		player_data.coins_per_second = Big.new(0)
		for item: ActiveItem in cps_items:
			player_data.coins_per_second.plusEquals(item.item.effect_factor * item.amount)


func get_active_buffs():
	return get_tree().get_nodes_in_group("active_buffs")


func load_json_array(path: String, arr: Array):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var parsed = JSON.parse_string(content)
	for line in parsed:
		arr.push_back(load(line))
	file.close()


const GAME_RESOURCE_WARMUP_JSON_PATHS: Array[String] = [
	"res://resources/blocks/blocks.json",
	"res://resources/mob_data/mobs.json",
	"res://resources/biomes/biomes.json",
	"res://resources/shop_items/shop_items.json",
]


func warmup_game_resources() -> void:
	# On web builds loading every game resource synchronously right when the
	# game scene enters is way too heavy and freezes the first seconds.
	# While the player is still in the main menu, pull one resource into the
	# `res://` cache per frame so entering the game stays cheap.
	for json_path in GAME_RESOURCE_WARMUP_JSON_PATHS:
		var file = FileAccess.open(json_path, FileAccess.READ)
		if file == null:
			continue
		var parsed: Variant = JSON.parse_string(file.get_as_text())
		file.close()
		if parsed is Array:
			for line in parsed:
				var res: Variant = load(line)
				if res is MobData:
					# mob scenes get loaded on first spawn otherwise
					load(res.scene_path)
				await get_tree().process_frame
