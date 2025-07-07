class_name SaveManager

const SAVE_PATH: String = "user://player_data.tres"
const TIMESTAMP_PATH: String = "user://elapsed_time.timestamp"
const COINS_PATH: String = "user://player_coins.dat"


static func save_player_data():
	_save_coins()
	ResourceSaver.save(Globals.player_data, SAVE_PATH)


static func load_player_data():
	if ResourceLoader.exists(SAVE_PATH):
		Globals.player_data = ResourceLoader.load(SAVE_PATH, "PlayerData")
	else:
		Globals.player_data = Globals.default_player_data
		
	_load_coins()


static func get_elapsed_time():
	var file = FileAccess.open(TIMESTAMP_PATH, FileAccess.READ)
	if !file:
		return -1
	var timestamp = file.get_float()
	file.close()
	var current_time = Time.get_unix_time_from_system()
	var elapsed_time = current_time - timestamp
	print_debug(elapsed_time)
	save_elapsed_time()
	return round(elapsed_time)


static func save_elapsed_time():
	var file = FileAccess.open(TIMESTAMP_PATH, FileAccess.WRITE)
	if !file:
		return
	print('saving exit time')
	var exit_unix_time = Time.get_unix_time_from_system()
	file.store_float(exit_unix_time)
	file.close()
	print('exit_unix_time saved')
	print(exit_unix_time)


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
