extends Control

signal buff_added(item: ShopItem)

@onready var buffs_container: HBoxContainer = %BuffsContainer

@onready var game: Node2D = $"/root/Game"

var buff_scene_preload = preload("res://scenes/buffs/buff.tscn")


func _on_buff_added(item: ShopItem) -> void:
	var buff_scene = buff_scene_preload.instantiate()
	item.buff.item_effect_factor = item.effect_factor
	item.buff.item_effect_type_as_string = item.effect_type_to_string()
	buff_scene.buff = item.buff
	buffs_container.add_child(buff_scene)
	game.handle_mouse_hover_ui_elements()
