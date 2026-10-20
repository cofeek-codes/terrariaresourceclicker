extends Control

@export var with_ad: bool:
	set = _set_with_ad

@onready var cursor: Cursor = $"/root/Game/CanvasLayer/Cursor"
@onready var settings_control: SettingsControl = %SettingsControl
@onready var ad_in: Control = %AdIn
@onready var ad_in_label: Label = %AdInLabel
@onready var ad_in_timer: Timer = %AdInTimer


var _displayed_seconds: int = -1


func _process(delta: float) -> void:
	if !with_ad:
		return
	var seconds: int = int(ad_in_timer.time_left)
	if seconds != _displayed_seconds:
		_displayed_seconds = seconds
		ad_in_label.text = tr("PAUSE_AD_IN") + ": " + str(seconds)


func _on_visibility_changed() -> void:
	if cursor:
		if self.visible:
			cursor.show_ui_cursor()
		else:
			cursor.show_game_cursor()


func _on_settings_control_back_button_pressed() -> void:
	PauseManager.unpause()


func _set_with_ad(value: bool):
	with_ad = value
	if with_ad:
		ad_in_timer.start()
		ad_in.show()
	else:
		settings_control.show()


func _on_ad_in_timer_timeout() -> void:
	with_ad = false
	ad_in.hide()
	settings_control.show()
	PlaygamaManager.show_interstitial()
