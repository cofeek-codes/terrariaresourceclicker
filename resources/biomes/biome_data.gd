extends Resource

class_name BiomeData

@export var title: String
@export var biome: Globals.Biome
@export var top_cell_coords: Dictionary[int, Vector2i]
@export var ground_cell_coords: Dictionary[int, Vector2i]
@export var background_texture: Texture2D


func _to_string() -> String:
	return title
