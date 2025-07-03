class_name SaveManager

const SAVE_PATH: String = "user://player_data.tres"
const TIMESTAMP_PATH: String = "user://elapsed_time.timestamp"



static func save_player_data():
	ResourceSaver.save(Globals.player_data, SAVE_PATH)

static func load_player_data():
	if ResourceLoader.exists(SAVE_PATH):
		Globals.player_data = ResourceLoader.load(SAVE_PATH, "PlayerData")
	else:
		Globals.player_data = Globals.default_player_data
		

static func get_elapsed_time():
	var file = FileAccess.open(TIMESTAMP_PATH, FileAccess.READ)
	if !file:
		return -1
	var timestamp = file.get_float()
	file.close()
	print_debug(Time.get_unix_time_from_system() - timestamp)
	return round(Time.get_unix_time_from_system() - timestamp)

static func save_elapsed_time():
	var file = FileAccess.open(TIMESTAMP_PATH, FileAccess.WRITE)
	if !file:
		return -1
	print('saving exit time')
	var exit_unix_time = Time.get_unix_time_from_system()
	file.store_float(exit_unix_time)
	file.close()
	print('exit_unix_time saved')
	print(exit_unix_time)
