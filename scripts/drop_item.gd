extends Node2D

@export var drop_item_data: DropItem

@onready var sprite: Sprite2D = $Sprite

@onready var inventory: Control = $"../GameUI/Inventory"
@onready var inventory_button: Control = $"../GameUI/InventoryButton"
@onready var inventory_panel: MarginContainer = inventory_button.get_node("OuterMargin")

const LERP_SPEED: float = 5
const LERP_DELAY: float = 5

var target_position: Vector2
var is_sound_played: bool = false

func _ready() -> void:
	sprite.texture = drop_item_data.texture
	var x = (inventory_button.position.x + inventory_panel.size.x / 2)
	var y = (inventory_button.position.y + inventory_panel.size.y / 2)
	target_position = Vector2(x, y) 
	
func _process(delta: float) -> void:
	self.position = self.position.lerp(target_position, LERP_SPEED * delta)
	# @NOTE: guessed some math again, idk how it works
	# @NOTE: may be unoptimized
	var time_to_reach_inventory = self.position.distance_to(target_position) / LERP_SPEED
	# print(time_to_reach_inventory)
	await get_tree().create_timer(time_to_reach_inventory - LERP_DELAY).timeout
	queue_free()
	

	
	
func _on_tree_exiting() -> void:
	inventory.emit_signal('item_pickup', drop_item_data)
