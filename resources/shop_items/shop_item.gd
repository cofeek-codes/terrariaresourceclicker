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
@export var base_price: int
@export var tier: int = 1
@export var damage: int
@export var texture: Texture2D
@export var effect_type: EffectType
@export var effect_factor: int
@export var type: ItemType
@export var buff: Buff

var price: int


func calculate_price(active_items: Array[ActiveItem]):
	price = base_price
	var item_amount: int = 0
	var item_idx = active_items.find_custom((func(i: ActiveItem): return i.item == self).bind())
	if item_idx != -1:
		item_amount = active_items[item_idx].amount
		price = base_price + (item_amount ** 3)
	return price


func get_description() -> String:
	return "+%d %s" % [effect_factor, effect_type_to_string()]


func effect_type_to_string():
	match effect_type:
		EffectType.CLICK_INCOME:
			return tr("FOR_CLICK")
		EffectType.TIME_INCOME:
			return tr("PER_SECOND")
