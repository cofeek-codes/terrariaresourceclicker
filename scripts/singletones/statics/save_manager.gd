class_name SaveManager

const SAVE_PATH: String = "user://player_data.tres"
const TIMESTAMP_PATH: String = "user://elapsed_time.timestamp"
const COINS_PATH: String = "user://player_coins.dat"


static func save_player_data():
	_save_coins()
	_save_active_timers()
	ResourceSaver.save(Globals.player_data, SAVE_PATH)


static func load_player_data():
	if save_exists():
		Globals.player_data = ResourceLoader.load(SAVE_PATH, "PlayerData")
		_load_coins()
	else:
		Globals.player_data = Globals.default_player_data


static func _save_coins():
	var coins_data = {
		"coins": Globals.player_data.coins.toScientific(true),
		"coins_per_second": Globals.player_data.coins_per_second.toScientific(true),
		"coins_per_click": Globals.player_data.coins_per_click.toScientific(true),
	}
	
	var file = FileAccess.open(COINS_PATH, FileAccess.WRITE)
	if !file:
		return
	file.store_var(coins_data, true)
	file.close()


static func _load_coins():
	var file = FileAccess.open(COINS_PATH, FileAccess.READ)
	if !file:
		return
	var coins_data = file.get_var(true)
	file.close()
	print_debug(coins_data)
	Globals.player_data.coins = Big.new(coins_data['coins']) if ("coins" in coins_data) else Big.new(0)
	Globals.player_data.coins_per_second = Big.new(coins_data['coins_per_second']) if ("coins_per_second" in coins_data) else Big.new(0)
	Globals.player_data.coins_per_click = Big.new(coins_data['coins_per_click']) if ("coins_per_click" in coins_data) else Big.new(1)


static func _save_active_timers():
	var buff_nodes: Array[Node] = Globals.get_active_buffs()
	for buff_node in buff_nodes:
		var timer = buff_node.get_child(buff_node.get_child_count() - 1)
		var existing_buff_idx = Globals.player_data.active_buffs.find_custom((func (ab: ActiveBuff): return ab.buff == buff_node.buff).bind())
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


static func save_exists():
	return FileAccess.file_exists(SAVE_PATH) && FileAccess.file_exists(COINS_PATH)
