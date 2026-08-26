extends Node

signal player_data_loaded

const SAVE_PATH: String = "user://player_data.tres"
const CLOUD_SAVE_TMP_PATH: String = "user://player_data_cloud.tres"
const SETTINGS_PATH: String = "user://settings.tres"
const CLOUD_SETTINGS_TMP_PATH: String = "user://settings_cloud.tres"


func save_player_data():
	_save_coins()
	_save_active_timers()

	_save_player_data()


func _save_player_data():
	var player_data_encoded = _tres_to_json(Globals.player_data)
	Bridge.storage.set("player_data", player_data_encoded, _on_save_player_data_cloud_completed)


func load_player_data():
	_load_player_data()


func _load_player_data():
	Bridge.storage.get("player_data", _on_load_player_data_completed)


func _post_load_player_data_cloud(player_data_loaded_json):
	print_debug("player_data_loaded_json")
	print_debug(player_data_loaded_json)

	var pd = _json_to_tres(player_data_loaded_json, PlayerData)

	if pd:
		Globals.player_data = pd
	else:
		Globals.player_data = Globals.default_player_data

	_load_coins()

	player_data_loaded.emit()


func _save_coins():
	Globals.player_data.coins_string = Globals.player_data.coins.toScientific(true)
	Globals.player_data.coins_per_second_string = Globals.player_data.coins_per_second.toScientific(true)
	Globals.player_data.coins_per_click_string = Globals.player_data.coins_per_click.toScientific(true)


func _load_coins():
	Globals.player_data.coins = Big.new(Globals.player_data.coins_string)
	Globals.player_data.coins_per_second = Big.new(Globals.player_data.coins_per_second_string)
	Globals.player_data.coins_per_click = Big.new(Globals.player_data.coins_per_click_string)


func _save_active_timers():
	var buff_nodes: Array[Node] = Globals.get_active_buffs()
	for buff_node in buff_nodes:
		var timer = buff_node.get_child(buff_node.get_child_count() - 1)
		var existing_buff_idx = Globals.player_data.active_buffs.find_custom((func(ab: ActiveBuff): return ab.buff == buff_node.buff).bind())
		if existing_buff_idx != -1:
			var existing_buff = Globals.player_data.active_buffs[existing_buff_idx]
			existing_buff.amount += 1
			if timer is Timer:
				existing_buff.time_left = timer.time_left
			print_debug(existing_buff.buff.to_dict())

		else:
			var new_active_buff = ActiveBuff.new()
			new_active_buff.buff = buff_node.buff
			new_active_buff.item_effect_factor = buff_node.item_effect_factor
			new_active_buff.item_effect_type_as_string = buff_node.item_effect_type_as_string
			new_active_buff.amount = 1
			if timer is Timer:
				new_active_buff.time_left = timer.time_left
			print_debug(new_active_buff.buff.to_dict())
			Globals.player_data.active_buffs.push_back(new_active_buff)


func _update_leaderboard():
	if PlaygamaManager.is_authorized():
		print("leaderboards type")
		print(Bridge.leaderboards.type)
		var leaderboard_id = Constants.COINS_LEADERBOARD_ID
		var coins: int = int(Globals.player_data.coins.toFloat())
		Bridge.leaderboards.set_score(leaderboard_id, coins, _on_update_leaderboard_completed)


func save_settings():
	var master_bus_index = AudioServer.get_bus_index("Master")
	var music_bus_index = AudioServer.get_bus_index("Music")
	var sound_bus_index = AudioServer.get_bus_index("Sound")

	var settings = Settings.new()
	settings.master_volume = AudioServer.get_bus_volume_linear(master_bus_index)
	settings.music_volume = AudioServer.get_bus_volume_linear(music_bus_index)
	settings.sound_volume = AudioServer.get_bus_volume_linear(sound_bus_index)

	_save_settings_cloud(settings)


func _save_settings_local(settings: Settings):
	ResourceSaver.save(settings, SETTINGS_PATH)


func _save_settings_cloud(settings: Settings):
	var settings_encoded = _tres_to_json(settings)
	Bridge.storage.set("settings", settings_encoded, _on_save_settings_cloud_completed)


func _on_save_settings_cloud_completed(success):
	if success:
		print("[%s]: SUCCESS" % _on_save_settings_cloud_completed.get_method().to_upper())
	else:
		print("[%s]: ERROR" % _on_save_settings_cloud_completed.get_method().to_upper())


func load_settings():
	_load_settings()


func load_settings_local():
	if FileAccess.file_exists(SETTINGS_PATH):
		return ResourceLoader.load(SETTINGS_PATH, "Settings")

	return null


func _load_settings():
	Bridge.storage.get("settings", _on_load_settings_completed)


func _on_load_settings_completed(success, data):
	if success:
		print("[%s]: SUCCESS" % _on_load_settings_completed.get_method().to_upper())
		print("data")
		print(data)
	else:
		print("[%s]: ERROR" % _on_load_settings_completed.get_method().to_upper())

	_post_load_settings(data)


func _post_load_settings(settings_json):
	var settings = _json_to_tres(settings_json, Settings)

	if !settings:
		settings = Globals.default_settings

	var master_bus_index = AudioServer.get_bus_index("Master")
	var music_bus_index = AudioServer.get_bus_index("Music")
	var sound_bus_index = AudioServer.get_bus_index("Sound")

	AudioServer.set_bus_volume_linear(master_bus_index, settings.master_volume)
	AudioServer.set_bus_volume_linear(music_bus_index, settings.music_volume)
	AudioServer.set_bus_volume_linear(sound_bus_index, settings.sound_volume)


func _on_update_leaderboard_completed(success: bool):
	if success:
		print("[%s]: SUCCESS" % _on_update_leaderboard_completed.get_method().to_upper())
	else:
		print("[%s]: ERROR" % _on_update_leaderboard_completed.get_method().to_upper())


func _on_save_player_data_cloud_completed(success: bool):
	if success:
		print("[%s]: SUCCESS" % _on_save_player_data_cloud_completed.get_method().to_upper())
	else:
		print("[%s]: ERROR" % _on_save_player_data_cloud_completed.get_method().to_upper())


func _on_load_player_data_completed(success: bool, data):
	if success:
		print("[%s]: SUCCESS" % _on_load_player_data_completed.get_method().to_upper())
		print("data")
		print(data)
	else:
		print("[%s]: ERROR" % _on_load_settings_completed.get_method().to_upper())

	_post_load_player_data_cloud(data)


func _tres_to_json(resource: Resource) -> String:
	return JSONConverter.resource_to_json(resource)


# Trere is not `String | null` in godot
func _json_to_tres(json_string: Variant, type_hint: Variant) -> Resource:
	if json_string:
		return JSONConverter.json_to_resource(json_string, type_hint)
	else:
		return null
