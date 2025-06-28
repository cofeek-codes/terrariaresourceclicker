extends Control

signal buff_added(buff: Buff)

@onready var buffs_container: HBoxContainer = %BuffsContainer

var buff_scene_preload = preload("res://scenes/buffs/buff.tscn")


func _on_buff_added(buff: Buff) -> void:
	var buff_scene = buff_scene_preload.instantiate()
	buff_scene.buff = buff
	buffs_container.add_child(buff_scene)
