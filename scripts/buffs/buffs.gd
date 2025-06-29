extends Control

signal buff_added(item: ShopItem)

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var buffs_container: GridContainer = %BuffsContainer

@onready var game: Node2D = $"/root/Game"

var buff_scene_preload = preload("res://scenes/buffs/buff.tscn")


func _ready() -> void:
	for item in player_data.active_items:
		if item.item.buff != null:
			buff_added.emit(item.item)

func _on_buff_added(item: ShopItem) -> void:
	var existing_buff_idx = buffs_container.get_children().find_custom((func(c): return c.buff == item.buff).bind())
	if existing_buff_idx != -1:
		var existing_buff = buffs_container.get_child(existing_buff_idx)
		print_debug(existing_buff.buff.title)
		existing_buff.buff = item.buff
		existing_buff.emit_signal('buff_updated')
	else:
		var buff_scene = buff_scene_preload.instantiate()
		item.buff.item_effect_factor = item.effect_factor
		item.buff.item_effect_type_as_string = item.effect_type_to_string()
		buff_scene.buff = item.buff
		buffs_container.add_child(buff_scene)
		game.handle_mouse_hover_ui_elements()
