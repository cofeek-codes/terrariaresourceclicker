extends VBoxContainer

@export var buff: Buff

@onready var buff_icon: TextureRect = %BuffIcon
@onready var buff_label: Label = %BuffLabel
@onready var buff_duration_timer: Timer = %BuffDurationTimer


func _ready() -> void:
	buff_icon.texture = buff.icon
	buff_duration_timer.wait_time = buff.duration
	buff_duration_timer.start()

func _process(delta: float) -> void:
	buff_label.text = "%d s" % [buff_duration_timer.time_left]
