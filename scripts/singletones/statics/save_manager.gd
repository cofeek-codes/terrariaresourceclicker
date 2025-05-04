class_name SaveManager

const SAVE_PATH: String = "user://player_data.tres"



static func save_player_data():
	ResourceSaver.save(Globals.player_data, SAVE_PATH)

static func load_player_data():
	if ResourceLoader.exists(SAVE_PATH):
		Globals.player_data = ResourceLoader.load(SAVE_PATH, "PlayerData")
	else:
		Globals.player_data = Globals.default_player_data
	
