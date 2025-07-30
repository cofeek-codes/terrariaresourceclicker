extends Control

@onready var shop_items_container: VBoxContainer = %ShopItems

var item_scene_preload = preload("res://scenes/shop/shop_item.tscn")

var shop_items = [
	preload("res://resources/shop_items/cooper_pickaxe/cooper_pickaxe.tres"),
	preload("res://resources/shop_items/mining_potion/mining_potion.tres"),
	preload("res://resources/shop_items/iron_pickaxe/iron_pickaxe.tres"),
]


func _ready() -> void:
	for item in shop_items:
		var item_scene = item_scene_preload.instantiate()
		item_scene.item = item
		shop_items_container.add_child(item_scene)
