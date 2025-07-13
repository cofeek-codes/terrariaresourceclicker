extends Control

signal buff_added_by_item(item: ShopItem)
signal buff_added_by_active_buff(active_buff: ActiveBuff)

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var buffs_container: GridContainer = %BuffsContainer

@onready var game: Node2D = $"/root/Game"

var buff_scene_preload = preload("res://scenes/buffs/buff.tscn")


func _ready() -> void:
	for buff in player_data.active_buffs:
		self.buff_added_by_active_buff.emit(buff)

func _on_buff_added_by_item(item: ShopItem) -> void:
	var existing_buff_idx = buffs_container.get_children().find_custom((func(c): return c.buff == item.buff).bind())
	if existing_buff_idx != -1:
		var existing_buff = buffs_container.get_child(existing_buff_idx)
		# print_debug(existing_buff.buff.title)
		existing_buff.buff = item.buff
		existing_buff.emit_signal('buff_updated')
	else:
		var buff_scene = buff_scene_preload.instantiate()
		buff_scene.item_effect_factor = item.effect_factor
		buff_scene.item_effect_type_as_string = item.effect_type_to_string()
		buff_scene.buff = item.buff
		print_debug(buff_scene.buff.to_dict())
		buffs_container.add_child(buff_scene)
		game.handle_mouse_hover_ui_elements()


func _on_buff_added_by_active_buff(active_buff: ActiveBuff) -> void:
	var buff_scene = buff_scene_preload.instantiate()
	buff_scene.buff = active_buff.buff
	buff_scene.item_effect_factor = active_buff.item_effect_factor
	buff_scene.item_effect_type_as_string = active_buff.item_effect_type_as_string
	buff_scene.buff_duration_left = active_buff.time_left
	buffs_container.add_child(buff_scene)
	game.handle_mouse_hover_ui_elements()
	
