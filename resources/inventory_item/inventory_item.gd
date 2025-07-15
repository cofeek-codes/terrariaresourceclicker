extends Resource

class_name InventoryItem

@export var item: DropItem
@export_range(1, Constants.INVENTORY_MAX_STACK) var amount: int = 1
