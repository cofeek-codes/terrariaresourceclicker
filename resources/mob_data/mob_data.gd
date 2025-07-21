extends Resource

class_name MobData

enum AIType {
	WALKING,
	FLYING,
	JUMPING
}

@export var name: String
@export var health: int
@export var drop: Array[DropItem]
@export var speed: float
@export var jump_force: float
@export var ai_type: AIType


func to_dict():
	var dict = {}
	for prop in get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var name = prop.name
			dict[name] = get(name)
	return dict
