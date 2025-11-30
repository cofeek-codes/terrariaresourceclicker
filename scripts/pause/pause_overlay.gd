extends Control

@onready var cursor: Cursor = $"/root/Game/CanvasLayer/Cursor"


func _on_visibility_changed() -> void:
	if cursor:
		if self.visible:
			cursor.show_ui_cursor()
		else:
			cursor.show_game_cursor()


func _on_settings_control_back_button_pressed() -> void:
	PauseManager.unpause()
