extends Control

signal resource_pickedup(item: String)

@onready var text_list_container: VBoxContainer = %TextListContainer
@onready var example_style_label: Label = %ExampleStyleLabel




func play_appear_animation(label: Label):
	var appear_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	label.self_modulate = Color.TRANSPARENT
	# @FIXME: sometimes may not play the animation
	appear_tween.tween_property(label, "self_modulate", Color.WHITE, 0.5)
	
	
func play_disappear_animation(label: Label):
	var disappear_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	print(disappear_tween)
	disappear_tween.tween_property(label, "self_modulate", Color.TRANSPARENT, 0.5)
	
func _on_resource_pickedup(item: String) -> void:
	var item_label = Label.new()
	item_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	item_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	item_label.text = "%s (%d)" % [item, 1]
	item_label.visible = true
	item_label.remove_meta('debug_label')
	text_list_container.add_child(item_label)
	play_appear_animation(item_label)


func _on_pickup_disappear_timer_timeout() -> void:
	print('pickup_text timeout')
	if text_list_container.get_child_count() > 0:
		var label_to_disappear = text_list_container.get_child(0)
		if label_to_disappear:
			play_disappear_animation(label_to_disappear)
			await get_tree().create_timer(0.5).timeout
			label_to_disappear.queue_free()
