extends VBoxContainer

@export var buff: Buff

@onready var buff_icon: TextureRect = %BuffIcon
@onready var buff_label: Label = %BuffLabel
@onready var buff_duration_timer: Timer = %BuffDurationTimer

@onready var player_data: PlayerData = Globals.get_player_data()

func _ready() -> void:
	buff_icon.texture = buff.icon
	buff_duration_timer.wait_time = buff.duration
	buff_duration_timer.start()
	buff_icon.tooltip_text = make_tooltip()
	print('buff tooltip')
	print(make_tooltip())

func _process(delta: float) -> void:
	buff_label.text = "%d s" % [buff_duration_timer.time_left]
 
func get_buff_amount():
	var item_idx: int = player_data.active_items.find_custom((func(i: ActiveItem): return i.item.buff == buff).bind())
	if item_idx != -1:
		var item: ActiveItem = player_data.active_items[item_idx]
		return item.amount
	
func make_tooltip():
	return "%s (x%d) - %s" % [buff.title, get_buff_amount(), make_description()]


func make_description():
	return "+%d %s" % [(buff.item_effect_factor * get_buff_amount()), buff.item_effect_type_as_string]
