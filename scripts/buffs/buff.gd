extends VBoxContainer

signal buff_updated

@export var buff: Buff
@export var item_effect_factor: int
@export var item_effect_type_as_string: String
@export var buff_duration_left: float = -1

@onready var buff_icon: TextureRect = %BuffIcon
@onready var buff_label: Label = %BuffLabel
@onready var buff_duration_timer: Timer = %BuffDurationTimer

@onready var player_data: PlayerData = Globals.get_player_data()


func _ready() -> void:
	print_debug(self.buff.to_dict())
	buff_icon.texture = buff.icon
	if buff_duration_left == -1:
		buff_duration_timer.wait_time = buff.duration
	else:
		buff_duration_timer.wait_time = buff_duration_left
	buff_duration_timer.start()
	buff_icon.tooltip_text = make_tooltip()
	print("buff tooltip")
	print(make_tooltip())


func _process(delta: float) -> void:
	if buff_duration_timer.time_left >= 60:
		buff_label.text = "%d m" % [round(buff_duration_timer.time_left / 60)]
	else:
		buff_label.text = "%d s" % [buff_duration_timer.time_left]


func get_buff_amount():
	var item_idx: int = player_data.active_items.find_custom((func(i: ActiveItem): return i.item.buff == buff).bind())
	if item_idx != -1:
		var item: ActiveItem = player_data.active_items[item_idx]
		return item.amount
	else:
		return 0


func make_tooltip():
	return "%s (x%d) - %s" % [buff.title, get_buff_amount(), make_description()]


func make_description():
	return "+%d %s" % [item_effect_factor * get_buff_amount(), item_effect_type_as_string]


func _on_buff_updated() -> void:
	buff_icon.tooltip_text = make_tooltip()


func _on_buff_duration_timer_timeout() -> void:
	print_debug("player_data.active_items before %s buff expired" % buff.title)
	print(player_data.active_items.map(func(item: ActiveItem): return item.item.title))
	player_data.active_items = player_data.active_items.filter(func(item: ActiveItem): return item.item.buff != buff)
	print_debug("player_data.active_items after %s buff expired" % buff.title)
	print(player_data.active_items.map(func(item: ActiveItem): return item.item.title))
	self.queue_free()
	Globals.update_income()
