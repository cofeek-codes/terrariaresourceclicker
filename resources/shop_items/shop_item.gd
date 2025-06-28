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
@export var tier: int = 1
@export var buff: Buff


func get_description() -> String:
	return "+%d %s" % [effect_factor, effect_type_to_string()] 

func effect_type_to_string():
	if effect_type == EffectType.CLICK_INCOME: 
		return "for click"
	else:
		return "per second"
