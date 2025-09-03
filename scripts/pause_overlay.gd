extends Control

@export var is_ad: bool

@onready var pause_label: Label = %PauseLabel
@onready var pre_ad_timer: Timer = %PreAdTimer


func _process(delta: float) -> void:
	if is_ad:
		pause_label.text = "%s: %d" % [tr("PAUSE_AD_IN"), pre_ad_timer.time_left]
	else:
		pause_label.text = tr("PAUSE")


func _on_pre_ad_timer_timeout() -> void:
	YandexManager.show_interstitial()


func _on_visibility_changed() -> void:
	if self.visible:
		#pre_ad_timer.start()
		pass
