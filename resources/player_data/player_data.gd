extends Resource

class_name PlayerData

@export var active_items: Array[ActiveItem]
@export var active_buffs: Array[ActiveBuff]
@export var tier: int = 1
@export var prev_tier: int = 1  # needed for `introduce_pickaxe` logic
@export var inventory: Array[InventoryItem]
@export var current_pickaxe: ShopItem
@export var current_biome: Globals.Biome
@export var coins_string: String = str(0)
@export var coins_per_second_string: String = str(0)
@export var coins_per_click_string: String = str(1)

var coins: Big = Big.new(0)
var coins_per_second: Big = Big.new(0)
var coins_per_click: Big = Big.new(1)


func get_pickaxe_texture() -> Texture2D:
	return current_pickaxe.texture


func calculate_damage():
#	@TODO: improve
	return current_pickaxe.damage * tier
