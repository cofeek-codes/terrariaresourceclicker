extends Control

signal cloudsave_state_changed

@onready var menu_container: VBoxContainer = %MenuContainer
@onready var audio_player: AudioStreamPlayer = %AudioPlayer
@onready var cloud_save_button: Button = %CloudSaveButton
@onready var auth_modal: Control = %AuthModal
@onready var logo: Control = %Logo

var game_scene_preload: PackedScene = preload("res://scenes/game.tscn")
var settings_scene_preload: PackedScene = preload("res://scenes/main_menu/settings.tscn")
var leaderboards_scene_preload: PackedScene = preload("res://scenes/main_menu/leaderboards.tscn")


func _ready() -> void:
	_init_locale()
	_set_cloudsave_btn_text()
	SaveManager.load_settings()
	for btn in get_tree().get_nodes_in_group("menu_buttons"):
		btn.mouse_entered.connect(_on_mouse_entered.bind(btn))
		btn.mouse_exited.connect(_on_mouse_exited.bind(btn))

	Bridge.platform.send_message(Bridge.PlatformMessage.GAME_READY)


func _set_cloudsave_btn_text(force_true: bool = false):
	# Had to modify it due it didn't change state on signal properly

	var s: String

	if force_true:
		s = "%s: %s" % [tr("MENU_CLOUDSAVE"), tr("ON")]
	else:
		s = "%s: %s" % [tr("MENU_CLOUDSAVE"), tr("ON") if YandexManager.is_authorized() else tr("OFF")]

	cloud_save_button.text = s


func _init_locale():
	TranslationServer.set_locale(Bridge.platform.language)
	_init_logo()


func _init_logo():
	if TranslationServer.get_locale() == "ru":
		logo.scale = Vector2(0.6, 0.6)
	else:
		logo.scale = Vector2(0.8, 0.8)


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


func _on_leaderboards_button_pressed() -> void:
	get_tree().change_scene_to_packed(leaderboards_scene_preload)


func _on_cloud_save_button_pressed() -> void:
	if !YandexManager.is_authorized():
		auth_modal.show()


func _on_cloudsave_state_changed() -> void:
	print("cloudsave_state_changed")
	_set_cloudsave_btn_text(true)
