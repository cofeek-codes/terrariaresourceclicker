extends Resource

class_name MobData

enum AIType {
	WALKING,
	FLYING,
	JUMPING
}

@export var name: String
@export var health: int
@export var drop: Array[DropItem]
@export var speed: float
@export var jump_force: float
@export var ai_type: AIType
