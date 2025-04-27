extends Control

@onready var inventory: Control = $"../Inventory"

func _ready() -> void:
	pass


func play_disappear_animation():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:x", -78, 0.3)

func _on_open_button_pressed() -> void:
	print('inventory button pressed')
	play_disappear_animation()
	inventory.emit_signal('inventory_open')
