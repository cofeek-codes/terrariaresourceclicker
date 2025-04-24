class_name SaveManager

const SAVE_PATH: String = "user://player_data.tres"

static var player_data: PlayerData

static func save_player_data():
	ResourceSaver.save(player_data, SAVE_PATH, ResourceSaver.FLAG_CHANGE_PATH)	

static func load_player_data():
	player_data = ResourceLoader.load(SAVE_PATH)
	
