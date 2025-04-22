extends PanelContainer

@export var item: ShopItem

@onready var item_image: TextureRect = %ItemImage
@onready var item_title_label: Label = %ItemTitleLabel
@onready var item_description_label: Label = %ItemDescriptionLabel



func _ready() -> void:
	item_image.texture = item.texture
	item_title_label.text = item.title
	item_description_label.text = item.get_description()
	
