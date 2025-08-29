extends Control

signal reward_completed

@onready var player_data: PlayerData = Globals.get_player_data()

@onready var button: Button = %Button
@onready var time_label: Label = %TimeLabel
@onready var cooldown_timer: Timer = %CooldownTimer


func _ready() -> void:
	time_label.hide()


func _process(delta: float) -> void:
	time_label.text = str(int(cooldown_timer.time_left))


func _on_button_pressed() -> void:
	YandexManager.show_rewarded()


func _on_cooldown_timer_timeout() -> void:
	player_data.coins_per_click.divideEquals(2)
	player_data.coins_per_second.divideEquals(2)
	button.disabled = false
	time_label.hide()


func _on_reward_completed() -> void:
	player_data.coins_per_click.multiplyEquals(2)
	player_data.coins_per_second.multiplyEquals(2)
	button.disabled = true
	cooldown_timer.start()
	time_label.show()
