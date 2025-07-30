extends Resource

class_name PlayerData

@export var active_items: Array[ActiveItem]
@export var active_buffs: Array[ActiveBuff]
@export var tier: int = 1
@export var inventory: Array[InventoryItem]
@export var current_pickaxe: ShopItem
@export var current_biome: Globals.Biome

var coins: Big = Big.new(0)
var coins_per_second: Big = Big.new(0)
var coins_per_click: Big = Big.new(1)


func get_pickaxe_texture() -> Texture2D:
	return current_pickaxe.texture


func calculate_damage():
#	@TODO: improve
	return tier * current_pickaxe.damage
