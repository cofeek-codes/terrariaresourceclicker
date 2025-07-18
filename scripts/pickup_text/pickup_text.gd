extends Control

signal resource_pickedup(item: String, amount: int)
signal stack_overflow(item: String)
signal item_sold(item: String, amount: int, price: int)

@onready var text_list_container: VBoxContainer = %TextListContainer
@onready var pickup_disappear_timer: Timer = %PickupDisappearTimer


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
	_add_label("%s (%d)" % [item, amount])
	if pickup_disappear_timer.is_stopped():
		pickup_disappear_timer.start()

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
		pickup_disappear_timer.start()


func _add_label(text: String):
	var item_label = init_label_props()
	item_label.text = text
	text_list_container.add_child(item_label)
	play_appear_animation(item_label)



func _add_error_label(text: String):
	var item_label = init_label_props()
	item_label.label_settings.font_color = Color.RED
	item_label.text = text
	text_list_container.add_child(item_label)
	play_appear_animation(item_label)



func _on_item_sold(item: String, amount: int, price: int) -> void:
	var label_text = _get_sold_label_text_localized(item, amount, price)
	_add_label(label_text)
	if pickup_disappear_timer.is_stopped():
		pickup_disappear_timer.start()


func _on_stack_overflow(item: String) -> void:
	_add_error_label("stack overflow: %s" % item)
	if pickup_disappear_timer.is_stopped():
		pickup_disappear_timer.start()


func _get_sold_label_text_localized(item: String, amount: int, price: int):
	var sold = tr("SOLD")
	var sold_for = tr("SOLD_FOR")
	var sold_coins = tr("SOLD_COINS")
	return "%s %s (%d) %s %d %s" % [sold, tr(item), amount, sold_for, price, sold_coins]
	 
	
