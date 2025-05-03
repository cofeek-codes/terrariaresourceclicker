class_name SaveManager

const SAVE_PATH: String = "user://player_data.tres"



static func save_player_data(player_data: PlayerData):
	ResourceSaver.save(player_data, SAVE_PATH, ResourceSaver.FLAG_CHANGE_PATH)	

static func load_player_data() -> PlayerData:
	var pd: PlayerData
	
	if FileAccess.file_exists(SAVE_PATH):
		pd = ResourceLoader.load(SAVE_PATH, "PlayerData")
		print('loaded save from file')
	else:
		pd = load("res://resources/player_data/player_data.tres")
		print('loaded default save')
	
	return pd
	
