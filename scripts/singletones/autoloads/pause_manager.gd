extends Node

var pause_overlay: Control


func _ready() -> void:
	self.tree_exiting.connect(_on_tree_exiting)

	if pause_overlay != null:
		pause_overlay.hide()


func _on_tree_exiting():
	if pause_overlay != null:
		pause_overlay.queue_free()


func pause(with_ad: bool = false):
	print("PauseManager.pause called")
	get_tree().paused = true
	AudioServer.set_bus_mute(0, true)
	Bridge.platform.send_message(Bridge.PlatformMessage.GAMEPLAY_STOPPED)

	if pause_overlay != null:
		pause_overlay.with_ad = with_ad
		pause_overlay.show()


func unpause():
	print("PauseManager.unpause called")
	get_tree().paused = false
	AudioServer.set_bus_mute(0, false)
	Bridge.platform.send_message(Bridge.PlatformMessage.GAMEPLAY_STARTED)

	if pause_overlay != null:
		pause_overlay.hide()


func get_overlay():
	pause_overlay = get_node_or_null("/root/Game/CanvasLayer/PauseOverlay")
	print("pause_overlay")
	print(pause_overlay)
