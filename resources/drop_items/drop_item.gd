extends Resource

class_name DropItem

@export var title: String
@export var price: int
@export var texture: Texture2D


func get_localized_title():
	return tr(title)


func _to_string() -> String:
	return title
