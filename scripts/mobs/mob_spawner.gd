extends Node2D

enum SpawnerSide {
	LEFT,
	RIGHT,
}

@export var spawner_side: SpawnerSide

var player_data: PlayerData = Globals.get_player_data()

var mobs: Array[MobData]

const MOBS_FILE_PATH: String = "res://resources/mob_data/mobs.json"


func _ready() -> void:
	_load_mobs()


func _load_mobs():
	Globals.load_json_array(MOBS_FILE_PATH, mobs)


func _spawn_mob() -> void:
	var filtered_mobs = mobs.filter(func(m: MobData): return m.biome == player_data.current_biome && m.tier <= player_data.tier)
	var mob_to_spawn = filtered_mobs.pick_random()
	var mob_scene: PackedScene = load(mob_to_spawn.scene_path)
	if is_instance_valid(mob_scene):
		var mob = mob_scene.instantiate()
		self.get_parent().add_child(mob)


func _on_spawn_cooldown_timer_timeout() -> void:
	print("mob spawner timeout")
	if get_tree().get_node_count_in_group("mobs") <= Constants.MAX_MOBS:
		var side = randi_range(0, 1)
		print("about to spawn mob on side %s" % SpawnerSide.keys()[spawner_side])
		print("current side: %s | chosen side: %s" % [SpawnerSide.keys()[side], SpawnerSide.keys()[spawner_side]])
		if side == spawner_side:
			_spawn_mob()
			print("mob count %d" % get_tree().get_node_count_in_group("mobs"))
	else:
		print("to many mobs %d" % get_tree().get_node_count_in_group("mobs"))
