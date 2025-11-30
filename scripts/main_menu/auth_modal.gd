extends Control


func _on_auth_button_pressed() -> void:
	PlaygamaManager.authorize()

	# re-check after auth attempt
	if PlaygamaManager.is_authorized():
		self.get_parent().emit_signal("cloudsave_state_changed")

	self.hide()


func _on_cancel_button_pressed() -> void:
	self.hide()
