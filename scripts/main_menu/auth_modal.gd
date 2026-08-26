extends Control


func _on_auth_button_pressed() -> void:
	PlaygamaManager.authorize()
	self.hide()


func _on_cancel_button_pressed() -> void:
	self.hide()
