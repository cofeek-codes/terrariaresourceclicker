extends PanelContainer

@onready var player_data: PlayerData = Globals.get_player_data()

@export var item: ShopItem

@onready var item_image: TextureRect = %ItemImage
@onready var item_title_label: Label = %ItemTitleLabel
@onready var item_description_label: Label = %ItemDescriptionLabel
@onready var buy_button: Button = %BuyButton



func _ready() -> void:
	item_image.texture = item.texture
	item_title_label.text = item.title
	item_description_label.text = item.get_description()
	
func _process(delta: float) -> void:
	if player_data.coins < item.price:
		buy_button.disabled = true
	else:
		buy_button.disabled = false
		
