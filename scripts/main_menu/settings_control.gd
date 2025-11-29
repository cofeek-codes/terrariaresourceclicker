extends Control

class_name SettingsControl

signal back_button_pressed

@onready var master_volume_slider: HSlider = %MasterVolumeSlider
@onready var music_volume_slider: HSlider = %MusicVolumeSlider
@onready var sound_volume_slider: HSlider = %SoundVolumeSlider
@onready var audio_player: AudioStreamPlayer = %AudioPlayer
@onready var back_button: Button = %BackButton

var master_bus_index = AudioServer.get_bus_index("Master")
var music_bus_index = AudioServer.get_bus_index("Music")
var sound_bus_index = AudioServer.get_bus_index("Sound")

var main_menu_scene_peload: PackedScene = load("res://scenes/main_menu/main_menu.tscn")


func _ready() -> void:
	master_volume_slider.value = AudioServer.get_bus_volume_linear(master_bus_index)
	music_volume_slider.value = AudioServer.get_bus_volume_linear(music_bus_index)
	sound_volume_slider.value = AudioServer.get_bus_volume_linear(sound_bus_index)


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(master_bus_index, value)


func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(music_bus_index, value)


func _on_sound_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(sound_bus_index, value)


func _on_back_button_pressed() -> void:
	SaveManager.save_settings()
	self.back_button_pressed.emit()


func _on_back_button_mouse_entered() -> void:
	back_button.pivot_offset = Vector2(back_button.size.x / 2, 0)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	audio_player.play()
	tween.tween_property(back_button, "scale", Vector2(1.2, 1.2), 0.3)


func _on_back_button_mouse_exited() -> void:
	back_button.pivot_offset = Vector2(back_button.size.x / 2, 0)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(back_button, "scale", Vector2.ONE, 0.3)
