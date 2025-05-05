extends Node2D

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var cursor: Node2D = %Cursor
@onready var block: Node2D = %Block
@onready var block_area: Area2D = block.get_node('BlockArea')



func _ready() -> void:
	get_tree().auto_accept_quit = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	print('coins loaded from file: %d' % player_data.coins)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('click'):
		cursor.handle_click()

# saves in different ways

func _on_save_timer_timeout() -> void:
	print('save_timer timeout')
	SaveManager.save_player_data()


func _on_tree_exiting() -> void:
	SaveManager.save_player_data()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print('about to exit...')
		SaveManager.save_player_data()
		get_tree().quit()
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		SaveManager.save_player_data()
		
