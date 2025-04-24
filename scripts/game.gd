extends Node2D

@export var player_data: PlayerData

@onready var cursor: Node2D = %Cursor
@onready var block: Node2D = %Block
@onready var block_area: Area2D = block.get_node('BlockArea')



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('click'):
		cursor.handle_click()
