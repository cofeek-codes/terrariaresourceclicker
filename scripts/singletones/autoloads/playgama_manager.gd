extends Node

var game: Node2D


func _ready():
	Bridge.advertisement.connect("interstitial_state_changed", _on_interstitial_state_changed)
	Bridge.game.connect("visibility_state_changed", _on_visibility_state_changed)
	Bridge.advertisement.connect("rewarded_state_changed", _on_rewarded_state_changed)
	Bridge.advertisement.connect("banner_state_changed", _on_banner_state_changed)


func show_banner():
	var position = Bridge.BannerPosition.BOTTOM
	var placement = "test_placement"
	Bridge.advertisement.show_banner(position, placement)


func _on_banner_state_changed(state):
	print_debug(state)


func show_interstitial():
	Bridge.advertisement.show_interstitial()

	SaveManager.save_player_data()


func show_rewarded():
	PauseManager.pause()
	Bridge.advertisement.show_rewarded()


func is_authorized():
	return Bridge.player.is_authorized


func authorize():
	var options = {}

	Bridge.player.authorize(options, _on_authorize_completed)


func _on_authorize_completed(success):
	if success:
		print("[PLAYGAMA]: Authorized")
	else:
		print("[PLAYGAMA]: Authorization error")


func _on_interstitial_state_changed(state):
	print_debug(state)
	match state:
		"closed", "failed":
			print("closing interstitial ad...")
			PauseManager.unpause()


func _on_visibility_state_changed(state):
	if state == "hidden":
		PauseManager.pause()
	else:
		PauseManager.unpause()


func _on_rewarded_state_changed(state):
	print_debug(state)
	match state:
		"rewarded":
			print("reward completed: emitting signal")
			var reward_button = get_node_or_null("/root/Game/CanvasLayer/GameUI/RewardButton")

			if reward_button == null:
				return

			reward_button.emit_signal("reward_completed")
			PauseManager.unpause()

		_:
			PauseManager.unpause()
