extends Control

@onready var menu_container: VBoxContainer = %MenuContainer
@onready var audio_player: AudioStreamPlayer = %AudioPlayer

var game_scene_preload: PackedScene = preload("res://scenes/game.tscn")
var settings_scene_preload: PackedScene = preload("res://scenes/main_menu/settings.tscn")
# var htp_scene_preload: PackedScene = preload("res://scenes/game.tscn")


func _ready() -> void:
	SaveManager.load_settings()
	for child in menu_container.get_children():
		if child is Button:
			child.mouse_entered.connect(_on_mouse_entered.bind(child))
			child.mouse_exited.connect(_on_mouse_exited.bind(child))

	Bridge.platform.send_message(Bridge.PlatformMessage.GAME_READY)


func _on_mouse_entered(button: Button):
	button.pivot_offset = Vector2(button.size.x / 2, 0)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	audio_player.play()
	tween.tween_property(button, "scale", Vector2(1.2, 1.2), 0.3)


func _on_mouse_exited(button: Button):
	button.pivot_offset = Vector2(button.size.x / 2, 0)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(button, "scale", Vector2.ONE, 0.3)


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene_preload)


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_packed(settings_scene_preload)
