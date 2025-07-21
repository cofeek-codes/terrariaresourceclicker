extends Mob

class_name MobSlime


func _ready() -> void:
	super._ready()
	await get_tree().create_timer(1).timeout
	_take_damage(35)
