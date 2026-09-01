extends Node2D

class_name World

@onready var left_wall_collider: CollisionShape2D = %LeftWallCollider
@onready var right_wall_collider: CollisionShape2D = %RightWallCollider


func _ready() -> void:
	get_viewport().size_changed.connect(_on_viewport_size_changed)


func _on_viewport_size_changed():
	right_wall_collider.position.x = get_viewport_rect().size.x
