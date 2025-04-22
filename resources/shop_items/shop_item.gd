extends Resource

class_name ShopItem

enum EffectType {
	TIME_INCOME,
	CLICK_INCOME,
}

enum ItemType {
	PICKAXE,
	BUFF,
}

@export var title: String
@export var price: int
@export var texture: Texture2D
@export var effect_type: EffectType
@export var effect_factor: int
@export var type: ItemType
@export var tier: int

func get_description() -> String:
	if effect_type == EffectType.CLICK_INCOME: 
		return "+%d for click" % effect_factor
	else:
		return "+%d per second" % effect_factor
