extends Node

var player_data_loaded_json: String

const SAVE_PATH: String = "user://player_data.tres"
const CLOUD_SAVE_TMP_PATH: String = "user://player_data_cloud.tres"
const SETTINGS_PATH: String = "user://settings.tres"


func save_player_data():
	_save_coins()
	_save_active_timers()

	_save_player_data_cloud()

	_update_leaderboard()


func _save_player_data_local():
	ResourceSaver.save(Globals.player_data, SAVE_PATH)


func _save_player_data_cloud():
	_save_player_data_local()  # save local anyway as a source for cloud
	var player_data_encoded = _tres_to_json(SAVE_PATH)
	Bridge.storage.set("player_data", player_data_encoded, _on_save_player_data_cloud_completed)


func load_player_data():
	_load_player_data_cloud()


func _load_player_data_local():
	if FileAccess.file_exists(SAVE_PATH):
		Globals.player_data = ResourceLoader.load(SAVE_PATH, "PlayerData")
	else:
		Globals.player_data = Globals.default_player_data

	_load_coins()


func _load_player_data_cloud():
	Globals.player_data = Globals.default_player_data
	Bridge.storage.get("player_data", _on_load_player_data_cloud_completed)


func _post_load_player_data_cloud(player_data_loaded_json: String):
	print_debug("player_data_loaded_json")
	print_debug(player_data_loaded_json)
	_json_to_tres(CLOUD_SAVE_TMP_PATH, player_data_loaded_json)
	var pd: PlayerData
	if !FileAccess.get_file_as_string(CLOUD_SAVE_TMP_PATH).is_empty():
		pd = load(CLOUD_SAVE_TMP_PATH)
	if pd != null:
		Globals.player_data = pd

		_load_coins()


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
	_save_settings_local(settings)
	var settings_encoded = _tres_to_json(SETTINGS_PATH)
	Bridge.storage.set("settings", settings_encoded, _on_save_settings_cloud_completed)


func _on_save_settings_cloud_completed(success):
	pass


func load_settings():
	var settings: Settings = null

	#if PlaygamaManager.is_authorized():
	#settings = load_settings_cloud()
	#else:

	settings = load_settings_local()

	if settings != null:
		var master_bus_index = AudioServer.get_bus_index("Master")
		var music_bus_index = AudioServer.get_bus_index("Music")
		var sound_bus_index = AudioServer.get_bus_index("Sound")

		AudioServer.set_bus_volume_linear(master_bus_index, settings.master_volume)
		AudioServer.set_bus_volume_linear(music_bus_index, settings.music_volume)
		AudioServer.set_bus_volume_linear(sound_bus_index, settings.sound_volume)


func load_settings_local():
	if FileAccess.file_exists(SETTINGS_PATH):
		return ResourceLoader.load(SETTINGS_PATH, "Settings")

	return null


func load_settings_cloud():
	return null


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


func _on_load_player_data_cloud_completed(success: bool, data):
	if success:
		print("[%s]: SUCCESS" % _on_load_player_data_cloud_completed.get_method().to_upper())
		print("data")
		print(data)
		if data != null:
			player_data_loaded_json = data
	else:
		print("[%s]: ERROR" % _on_load_player_data_cloud_completed.get_method().to_upper())

	_post_load_player_data_cloud(player_data_loaded_json)


func _tres_to_json(file_path: String):
	var player_data_file = FileAccess.open(file_path, FileAccess.READ)
	var player_data_as_text = player_data_file.get_as_text()
	player_data_file.close()
	return JSON.stringify(player_data_as_text)


func _json_to_tres(file_path: String, json_string: String):
	var data_file = FileAccess.open(file_path, FileAccess.WRITE)
	var json = JSON.new()
	var json_parsed = json.parse(json_string)
	if json_parsed != OK:
		return null

	var json_parsed_data = json.data
	data_file.store_string(json_parsed_data)
	data_file.close()
