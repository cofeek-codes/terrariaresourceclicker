extends Node2D

@export var drop_item_data: DropItem

@onready var sprite: Sprite2D = $Sprite

@onready var inventory: Control = $"../GameUI/Inventory"
@onready var inventory_button: Control = $"../GameUI/InventoryButton"
@onready var inventory_panel: MarginContainer = inventory_button.get_node("OuterMargin")
@onready var inventory_reach_timer: Timer = $InventoryReachTimer

const LERP_SPEED: float = 5
const LERP_DELAY: float = 5

var target_position: Vector2


func _ready() -> void:
	sprite.texture = drop_item_data.texture
	var x = (inventory_button.position.x + inventory_panel.size.x / 2)
	var y = (inventory_button.position.y + inventory_panel.size.y / 2)
	target_position = Vector2(x, y) 
	
func _process(delta: float) -> void:
	self.global_position = self.global_position.lerp(target_position, LERP_SPEED * delta)
	# @NOTE: fixed timer leak, but locked timer to fixed 0.5 seconds for now
	

func _on_tree_exiting() -> void:
	inventory.emit_signal('item_added', drop_item_data)


func _on_inventory_reach_timer_timeout() -> void:
	self.queue_free()
