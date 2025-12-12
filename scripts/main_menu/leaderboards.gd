extends Control

@onready var dynamic_table: DynamicTable = %DynamicTable
@onready var table_margin_container: MarginContainer = $TableMarginContainer
@onready var back_button: Button = %BackButton
@onready var audio_player: AudioStreamPlayer = %AudioPlayer
@onready var avatar_http_request: HTTPRequest = %AvatarHTTPRequest

var main_menu_scene_preload: PackedScene = load("res://scenes/main_menu/main_menu.tscn")

var avatar_request_count: int = 0

var headers: Array[String] = [
	tr("LDB_RANK"),
	tr("LDB_AVATAR") + "|image",
	tr("LDB_NAME"),
	tr("LDB_COINS_EARNED"),
]

var data: Array = []


func _ready() -> void:
	dynamic_table.set_headers(headers)
	_fetch_leaderboard()


func _fetch_leaderboard():
	var leaderboard_id = Constants.COINS_LEADERBOARD_ID
	Bridge.leaderboards.get_entries(leaderboard_id, _on_fetch_leaderboard_completed)


func _on_fetch_leaderboard_completed(success, entries):
	for entry in entries:
		print("leaderboard entry")
		print(entry)
		if entry.photo:
			_get_entry_image(str(entry.photo), entries.find(entry))
			avatar_request_count += 1
		data.push_back([str(entry.rank), null, str(entry.name), int(entry.score)])
		dynamic_table.set_data(data)


func _get_entry_image(image_url: String, entry_idx: int):
	var error = avatar_http_request.request(image_url)
	if error != OK:
		print("Avatar HTTP Request Error")


func _on_back_button_mouse_entered() -> void:
	back_button.pivot_offset = Vector2(back_button.size.x / 2, 0)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	audio_player.play()
	tween.tween_property(back_button, "scale", Vector2(1.2, 1.2), 0.3)


func _on_back_button_mouse_exited() -> void:
	back_button.pivot_offset = Vector2(back_button.size.x / 2, 0)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(back_button, "scale", Vector2.ONE, 0.3)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene_preload)


func _on_avatar_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Avatar HTTP Request Error")

	var image = Image.new()
	image.load_png_from_buffer(body)
	var texture = ImageTexture.create_from_image(image)
	print("data in _on_avatar_http_request_request_completed")
	print(data)
	print("avatar_request_count in _on_avatar_http_request_request_completed: %d" % avatar_request_count)
	var current_entry: Array = data[avatar_request_count - 1]
	current_entry[1] = texture
	print("updated current entry")
	print(current_entry)
	print(data)
	dynamic_table.set_data(data)
