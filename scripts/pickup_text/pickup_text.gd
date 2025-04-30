extends Control

signal resource_pickedup(item: String, amount: int)

@onready var text_list_container: VBoxContainer = %TextListContainer
@onready var example_style_label: Label = %ExampleStyleLabel



func play_appear_animation(label: Label):
	var appear_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	label.self_modulate = Color.TRANSPARENT
	appear_tween.tween_property(label, "self_modulate", Color.WHITE, 0.5)
	
	
func play_disappear_animation(label: Label):
	# @FIXME: wierd outline behaviour
	var disappear_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	#var outline_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	disappear_tween.tween_property(label, "self_modulate", Color.TRANSPARENT, 0.5)
	#outline_tween.tween_property(label, "label_settings:outline_size", 0, 0.3)
	disappear_tween.tween_callback(label.queue_free)
	
func _on_resource_pickedup(item: String, amount: int) -> void:
	var item_label = init_label_props()
	item_label.text = "%s (%d)" % [item, amount]
	text_list_container.add_child(item_label)
	play_appear_animation(item_label)

func init_label_props() -> Label:
	var label = Label.new()
	var label_settings = LabelSettings.new()
	label_settings.outline_color = Color.BLACK
	label_settings.outline_size = 2
	label.label_settings = label_settings
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	return label



func _on_pickup_disappear_timer_timeout() -> void:
	# print('pickup_text timeout')
	if text_list_container.get_child_count() > 0:
		var label_to_disappear = text_list_container.get_child(0)
		if label_to_disappear:
			play_disappear_animation(label_to_disappear)
