extends Resource

class_name Buff

@export var title: String
@export var icon: Texture2D

@export_custom(PROPERTY_HINT_NONE, "suffix:s") var duration: int

var item_effect_factor: int
var item_effect_type_as_string: String
