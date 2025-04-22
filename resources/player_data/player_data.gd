extends Resource

class_name PlayerData

@export var coins: int
@export var active_items: Array[ShopItem]
@export var tier: int = 1



func get_pickaxe_texture() -> Texture2D:
	var pickaxes: Array[ShopItem] = active_items.filter(func(item: ShopItem): return item.type == ShopItem.ItemType.PICKAXE)
	var target_pickaxe = pickaxes.reduce(func(prev, new): return new if new.tier > prev.tier else prev)
	print_debug(target_pickaxe)
	return target_pickaxe.texture
