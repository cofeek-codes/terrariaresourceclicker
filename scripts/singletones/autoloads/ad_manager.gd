extends Node

var game: Node2D


func _ready():
	Bridge.advertisement.connect("interstitial_state_changed", _on_interstitial_state_changed)


func show_interstitial():
	game = get_node_or_null("/root/Game")
	if game == null:
		return

	game.pause()
	Bridge.advertisement.show_interstitial()


func show_rewarded():
	# @TODO: implement
	pass


func _on_interstitial_state_changed(state):
	print_debug(state)
	match state:
		"closed", "failed":
			print("closing interstitial ad...")
			game.unpause()
