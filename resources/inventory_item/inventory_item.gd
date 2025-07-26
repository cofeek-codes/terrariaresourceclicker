extends Resource

class_name InventoryItem

@export var item: DropItem
@export_range(1, Constants.INVENTORY_MAX_STACK) var amount: int = 1


func _to_string() -> String:
	return "%s (%d)" % [item.title, amount]
