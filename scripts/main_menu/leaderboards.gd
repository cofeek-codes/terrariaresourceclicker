extends Control

@onready var dynamic_table: DynamicTable = %DynamicTable
@onready var table_margin_container: MarginContainer = $TableMarginContainer
@onready var back_button: Button = %BackButton
@onready var audio_player: AudioStreamPlayer = %AudioPlayer

var avatar_preload = preload("res://assets/avatar.webp")
var main_menu_scene_preload: PackedScene = load("res://scenes/main_menu/main_menu.tscn")

var headers: Array[String] = [
	"Avatar|image",
	"Name",
	"Score",
]

var data: Array = [
	[avatar_preload, "User", 15],
	[avatar_preload, "User2", 30],
	[avatar_preload, "User3", 45],
]


func _ready() -> void:
	dynamic_table.set_headers(headers)
	dynamic_table.set_data(data)


func _on_back_button_mouse_entered() -> void:
	back_button.pivot_offset = Vector2(back_button.size.x / 2, 0)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	audio_player.play()
	tween.tween_property(back_button, "scale", Vector2(1.2, 1.2), 0.3)


func _on_back_button_mouse_exited() -> void:
	back_button.pivot_offset = Vector2(back_button.size.x / 2, 0)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(back_button, "scale", Vector2.ONE, 0.3)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene_preload)
