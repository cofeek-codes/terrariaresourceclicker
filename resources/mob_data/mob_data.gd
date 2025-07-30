extends Resource

class_name MobData

enum AIType {
	WALKING,
	FLYING,
	JUMPING,
}

@export var name: String
@export var health: int
@export var tier: int = 1
@export var drop: Dictionary[DropItem, Vector2i]  # using Vector2i to store drop min-max range
@export var speed: float
@export var jump_force: float
@export var ai_type: AIType
@export var hit_sound: AudioStream
@export var death_sound: AudioStream
@export var biome: Globals.Biome
@export_file("*.tscn") var scene_path: String


func to_dict():
	var dict = {}
	for prop in get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var name = prop.name
			dict[name] = get(name)
	return dict
