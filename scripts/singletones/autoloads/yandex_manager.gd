extends Node

var game: Node2D


func _ready():
	Bridge.advertisement.connect("interstitial_state_changed", _on_interstitial_state_changed)
	Bridge.game.connect("visibility_state_changed", _on_visibility_state_changed)
	Bridge.advertisement.connect("rewarded_state_changed", Callable(self, "_on_rewarded_state_changed"))


func show_interstitial():
	game = get_node_or_null("/root/Game")
	if game == null:
		return

	game.pause()
	Bridge.advertisement.show_interstitial()
	SaveManager.save_player_data()


func show_rewarded():
	game = get_node_or_null("/root/Game")
	if game == null:
		return

	game.pause()
	Bridge.advertisement.show_rewarded()


func is_authorized():
	return Bridge.player.is_authorized


func authorize():
	var options = {"scopes": true}

	Bridge.player.authorize(options, _on_player_authorize_completed)


func _on_player_authorize_completed(success: bool):
	if success:
		print("[YANDEX]: Authorized")
	else:
		print("[YANDEX]: Authorization error")


func _on_interstitial_state_changed(state):
	print_debug(state)
	match state:
		"closed", "failed":
			print("closing interstitial ad...")
			game.unpause()


func _on_visibility_state_changed(state):
	game = get_node_or_null("/root/Game")

	if state == "hidden":
		if game != null:
			game.pause()
		else:
			get_tree().paused = true
			Bridge.platform.send_message(Bridge.PlatformMessage.GAMEPLAY_STOPPED)
	else:
		if game != null:
			game.unpause()
		else:
			get_tree().paused = false
			Bridge.platform.send_message(Bridge.PlatformMessage.GAMEPLAY_STARTED)


func _on_rewarded_state_changed(state):
	print_debug(state)
	match state:
		"rewarded":
			print("reward completed: emitting signal")
			var reward_button = get_node_or_null("/root/Game/CanvasLayer/GameUI/RewardButton")
			if reward_button == null:
				return

			reward_button.emit_signal("reward_completed")
			game.unpause()

		_:
			game.unpause()
