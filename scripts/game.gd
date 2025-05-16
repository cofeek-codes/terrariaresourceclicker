extends Node2D

signal introduce_pickaxe(pickaxe_texture: Texture2D)

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var cursor: Node2D = %Cursor
@onready var block: Node2D = %Block
@onready var canvas_layer: CanvasLayer = %CanvasLayer

@onready var block_area: Area2D = block.get_node('BlockArea')

var new_pickaxe_scene_preload = preload("res://scenes/animations/introduce_pickaxe.tscn")

func _ready() -> void:
	get_tree().auto_accept_quit = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	print('coins loaded from file: %d' % player_data.coins)
	handle_mouse_hover_ui_elements()
	

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
		
func ui_mouse_entered():
	cursor.show_ui_cursor()
	
func ui_mouse_exited():
	cursor.show_game_cursor()
	
	
func handle_mouse_hover_ui_elements():
	var ui_nodes = get_tree().get_nodes_in_group("ui_cursor")
	for node in ui_nodes:
		node.mouse_entered.connect(ui_mouse_entered)
		node.mouse_exited.connect(ui_mouse_exited)
		


func _on_introduce_pickaxe(pickaxe_texture: Texture2D) -> void:
	var new_pickaxe_scene = new_pickaxe_scene_preload.instantiate()
	new_pickaxe_scene.pickaxe_texture = pickaxe_texture
	canvas_layer.add_child(new_pickaxe_scene)
	
