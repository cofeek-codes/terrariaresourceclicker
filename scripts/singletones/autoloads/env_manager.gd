extends Node

@onready var player_data = Globals.get_player_data()

@onready var biome_timer: Timer = %BiomeTimer
@onready var background: TextureRect = $"/root/Game/CanvasLayer/GameUI/BgWrapper/Background"
@onready var tilemap: TileMapLayer = $"/root/Game/CanvasLayer/World/TileMapLayer"
@onready var canvas_modulate: CanvasModulate = $"/root/Game/CanvasLayer/CanvasModulate"
@onready var background_music_player: AudioStreamPlayer = $"/root/BackgroundMusic"

var biomes: Array[BiomeData]

var previous_biome: BiomeData
var current_biome: BiomeData

const BIOMES_FILE_PATH: String = "res://resources/biomes/biomes.json"
const BIOME_CHANGE_TWEEN_DURATION: float = 3.5


func _ready() -> void:
	biome_timer.start()
	_load_biomes()
	current_biome = biomes[biomes.find_custom((func(b: BiomeData): return b.biome == player_data.current_biome).bind())]
	previous_biome = biomes[0]  # set first `previous_biome` to forest as it dosen't matter
	_set_texture()
	_set_tiles()
	_set_track()


func _load_biomes():
	Globals.load_json_array(BIOMES_FILE_PATH, biomes)


func _change_biome_start():
	print("changing biome from %s to %s" % [previous_biome, current_biome])
	var disappear_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	disappear_tween.tween_property(canvas_modulate, "color", Color.BLACK, BIOME_CHANGE_TWEEN_DURATION)
	disappear_tween.tween_callback(_change_biome_end)


func _change_biome_end():
	_set_texture()
	_set_tiles()
	_set_track()

	var appear_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	appear_tween.tween_property(canvas_modulate, "color", Color.WHITE, BIOME_CHANGE_TWEEN_DURATION)

	biome_timer.start()


func _set_texture():
	background.texture = current_biome.background_texture


func _set_track():
	background_music_player.stop()
	background_music_player.stream = current_biome.track
	background_music_player.play()


func _set_tiles():
	for cell_pos in tilemap.get_used_cells_by_id(previous_biome.ground_cell_coords.keys()[0]):
		tilemap.set_cell(cell_pos, current_biome.ground_cell_coords.keys()[0], current_biome.ground_cell_coords.values()[0])
	for cell_pos in tilemap.get_used_cells_by_id(previous_biome.top_cell_coords.keys()[0]):
		tilemap.set_cell(cell_pos, current_biome.top_cell_coords.keys()[0], current_biome.top_cell_coords.values()[0])


func _on_biome_timer_timeout() -> void:
	var other_biomes: Array = biomes.filter(func(b: BiomeData): return b.biome != player_data.current_biome)
	var new_biome: BiomeData = other_biomes.pick_random()
	player_data.current_biome = new_biome.biome
	previous_biome = current_biome
	current_biome = new_biome
	_change_biome_start()
