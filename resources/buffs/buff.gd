extends Resource

class_name Buff

@export var item: ActiveItem
@export var icon: Texture2D

@export_custom(PROPERTY_HINT_NONE, "suffix:s") var duration: int


func get_tooltip():
	return "%s (x%d) - %s" % [item.item.title, item.amount, item.item.get_description()]
