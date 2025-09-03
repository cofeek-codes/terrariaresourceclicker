extends Node2D

signal introduce_pickaxe(pickaxe_texture: Texture2D)

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var cursor: Node2D = %Cursor
@onready var block: Node2D = %Block
@onready var canvas_layer: CanvasLayer = %CanvasLayer

@onready var block_area: Area2D = block.get_node("BlockArea")

var new_pickaxe_scene_preload = preload("res://scenes/animations/introduce_pickaxe.tscn")

var on_before_unload_callback: JavaScriptObject


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	print("coins loaded from file: %s" % player_data.coins.toAA(true))
	handle_mouse_hover_ui_elements()
	PauseManager.get_overlay()

	Bridge.platform.send_message(Bridge.PlatformMessage.GAMEPLAY_STARTED)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		cursor.handle_click()


# saves in different ways
func _on_save_timer_timeout() -> void:
	print("save_timer timeout")
	SaveManager.save_player_data()


func ui_mouse_entered():
	cursor.show_ui_cursor()


func ui_mouse_exited():
	cursor.show_game_cursor()


func handle_mouse_hover_ui_elements():
	var ui_nodes = get_tree().get_nodes_in_group("ui_cursor")
	for node in ui_nodes:
		if !node.is_connected("mouse_entered", ui_mouse_entered) || !node.is_connected("mouse_exited", ui_mouse_exited):
			node.mouse_entered.connect(ui_mouse_entered)
			node.mouse_exited.connect(ui_mouse_exited)


func _on_introduce_pickaxe(pickaxe_texture: Texture2D) -> void:
	var new_pickaxe_scene = new_pickaxe_scene_preload.instantiate()
	new_pickaxe_scene.pickaxe_texture = pickaxe_texture
	canvas_layer.add_child(new_pickaxe_scene)


func _on_ad_timer_timeout() -> void:
	print("_on_ad_timer_timeout")
	PauseManager.pause()
