extends Resource

class_name PlayerData

@export var coins: int
@export var coins_per_second: int
@export var coins_per_click: int = 1
@export var active_items: Array[ActiveItem]
@export var tier: int = 1
@export var inventory: Array[InventoryItem]

var elapsed_time: float


func get_pickaxe_texture() -> Texture2D:
	var items = active_items.map(func(ai: ActiveItem): return ai.item)
	var pickaxes = items.filter(func(item: ShopItem): return item.type == ShopItem.ItemType.PICKAXE)
	# @TODO: maybe just get pickaxe by player tier
	var target_pickaxe = pickaxes.reduce(func(prev, new): return new if new.tier > prev.tier else prev)
	return target_pickaxe.texture


func calculate_damage():
#	@TODO: improve
	return tier
