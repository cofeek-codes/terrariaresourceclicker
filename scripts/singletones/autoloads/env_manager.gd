extends Node

@onready var player_data = Globals.get_player_data()

@onready var background: TextureRect = $"/root/Game/CanvasLayer/GameUI/BgWrapper/Background"
@onready var tilemap: TileMapLayer = $"/root/Game/CanvasLayer/World/TileMapLayer"
@onready var canvas_modulate: CanvasModulate = $"/root/Game/CanvasLayer/CanvasModulate"

var biomes: Array[BiomeData] = [
	preload("res://resources/biomes/forest/forest.tres"),
	preload("res://resources/biomes/winter/winter.tres"),
]

var previous_biome: BiomeData
var current_biome: BiomeData


func _ready() -> void:
	current_biome = biomes[biomes.find_custom((func(b: BiomeData): return b.biome == player_data.current_biome).bind())]


func _change_biome():
	print("changing biome from %s to %s" % [previous_biome, current_biome])
	var disappear_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	disappear_tween.tween_property(canvas_modulate, "color", Color.BLACK, 3)
	canvas_modulate.color = Color.BLACK
	_set_texture()
	_set_tiles()
	var appear_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	appear_tween.tween_property(canvas_modulate, "color", Color.WHITE, 3)


func _set_texture():
	background.texture = current_biome.background_texture


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
	_change_biome()
