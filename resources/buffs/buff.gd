extends Resource

class_name Buff

@export var title: String
@export var icon: Texture2D

@export_custom(PROPERTY_HINT_NONE, "suffix:s") var duration: int


func to_dict():
	return {
		"title": title,
		"icon": icon.resource_path,
		"duration": duration,
	}
