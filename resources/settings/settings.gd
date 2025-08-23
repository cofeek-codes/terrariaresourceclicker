extends Resource

class_name Settings

@export var master_volume: float = 1.0
@export var music_volume: float = 1.0
@export var sound_volume: float = 1.0


func to_dict():
	var dict = {}
	for prop in get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var name = prop.name
			dict[name] = get(name)
	return dict


func from_dict(dict: Dictionary):
	master_volume = dict["master_volume"]
	music_volume = dict["music_volume"]
	sound_volume = dict["sound_volume"]
