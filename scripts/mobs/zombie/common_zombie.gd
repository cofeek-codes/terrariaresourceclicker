extends Mob

@onready var idle_audio_player: AudioStreamPlayer = $IdleAudioPlayer
@onready var idle_sound_timer: Timer = $IdleSoundTimer


func _ready() -> void:
	super._ready()

	mob_data = mob_data as ZombieMobData

	idle_audio_player.stream = mob_data.idle_sound


func _on_idle_sound_timer_timeout() -> void:
	idle_audio_player.play()
	idle_sound_timer.wait_time = randf_range(3, 5)
	idle_sound_timer.start()
