extends Control

@onready var shop_items_container: VBoxContainer = %ShopItems
@onready var scroll_container: ScrollContainer = %ScrollContainer

var item_scene_preload = preload("res://scenes/shop/shop_item.tscn")

var shop_items: Array[ShopItem]

const SHOP_ITEMS_PATH: String = "res://resources/shop_items/shop_items.json"


func _ready() -> void:
	_init_scroll()
	_load_shop_items()
	for item in shop_items:
		var item_scene = item_scene_preload.instantiate()
		item_scene.item = item
		shop_items_container.add_child(item_scene)


func _load_shop_items():
	Globals.load_json_array(SHOP_ITEMS_PATH, shop_items)


func _init_scroll():
	if OS.has_feature("web_android") || OS.has_feature("web_ios") || OS.has_feature("mobile"):
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_ALWAYS
