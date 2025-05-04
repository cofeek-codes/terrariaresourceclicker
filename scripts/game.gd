extends Node2D

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var cursor: Node2D = %Cursor
@onready var block: Node2D = %Block
@onready var block_area: Area2D = block.get_node('BlockArea')



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	print('coins loaded from file: %d' % player_data.coins)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('click'):
		cursor.handle_click()


func _notification(what: int) -> void:
	if (what == NOTIFICATION_WM_CLOSE_REQUEST):
		print('about to exit...')
		SaveManager.save_player_data()
