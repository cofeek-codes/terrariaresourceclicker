extends Node2D

enum SpawnerSide {
	LEFT,
	RIGHT
}

@export var spawner_side: SpawnerSide

var mob_scenes: Array[String] = [
	"res://scenes/mobs/slimes/red_slime.tscn"
]


func _spawn_mob() -> void:
	var mob_to_spawn = mob_scenes.pick_random()
	var mob_scene: PackedScene = load(mob_to_spawn)
	if is_instance_valid(mob_scene):
		var mob = mob_scene.instantiate()
		self.get_parent().add_child(mob)


func _on_spawn_cooldown_timer_timeout() -> void:
	print('mob spawner timeout')
	if get_tree().get_node_count_in_group('mobs') <= Constants.MAX_MOBS * 2: # (* 2) due to some spawner/group bug
		var side = randi_range(0, 1)
		print('about to spawn mob on side %s' % SpawnerSide.keys()[spawner_side])
		print(side, spawner_side)
		print(SpawnerSide.keys()[side] + " == " + SpawnerSide.keys()[spawner_side])
		if side == spawner_side:
			_spawn_mob()
	else:
		print('to many mobs %d' % get_tree().get_node_count_in_group('mobs'))
