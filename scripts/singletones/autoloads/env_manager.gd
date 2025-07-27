extends Node

@onready var player_data = Globals.get_player_data()

@onready var background: TextureRect = $"/root/Game/CanvasLayer/GameUI/BgWrapper/Background"
@onready var tilemap: TileMapLayer = $"/root/Game/CanvasLayer/World/TileMapLayer"
@onready var canvas_modulate: CanvasModulate = $"/root/Game/CanvasLayer/CanvasModulate"

var forest_texture = preload("res://assets/backgrounds/bg_forest.webp")
var winter_texture = preload("res://assets/backgrounds/bg_winter.webp")

var current_texture: Texture2D


func change_time_of_day():
	pass


func _change_biome():
	print("should change biome")
	var disappear_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	disappear_tween.tween_property(canvas_modulate, "color", Color.BLACK, 3)
	canvas_modulate.color = Color.BLACK
	_set_texture()
	_set_tiles()
	var appear_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	appear_tween.tween_property(canvas_modulate, "color", Color.WHITE, 3)


func _set_texture():
	match player_data.current_biome:
		Globals.Biome.FOREST:
			current_texture = forest_texture
		Globals.Biome.WINTER:
			current_texture = winter_texture

	background.texture = current_texture


func _set_tiles():
	pass


func _on_biome_timer_timeout() -> void:
	var other_biomes: Array = Globals.Biome.values().filter(func(v: int): return v != player_data.current_biome)
	var new_biome: int = other_biomes.pick_random()
	player_data.current_biome = new_biome
	_change_biome()
