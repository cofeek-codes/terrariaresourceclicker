extends PanelContainer

@onready var player_data: PlayerData = Globals.get_player_data()

@export var item: ShopItem

@onready var item_image: TextureRect = %ItemImage
@onready var item_title_label: Label = %ItemTitleLabel
@onready var item_description_label: Label = %ItemDescriptionLabel
@onready var buy_button: Button = %BuyButton

@onready var buy_audio_player: AudioStreamPlayer = $BuyAudioPlayer


func _ready() -> void:
	item_image.texture = item.texture
	item_title_label.text = item.title
	item_description_label.text = item.get_description()
	
func _process(delta: float) -> void:
	if player_data.coins < item.price:
		buy_button.disabled = true
	else:
		buy_button.disabled = false
		

func _on_buy_button_pressed() -> void:
	buy_item()


func buy_item():
	player_data.coins -= item.price
	buy_audio_player.play()
	match item.type:
		item.ItemType.PICKAXE:
			print('about to buy pickaxe: %s' % item.title)
		item.ItemType.BUFF:
			print('about to buy buff: %s' % item.title)
			match item.effect_type:
				item.EffectType.TIME_INCOME:
					player_data.coins_per_second += item.effect_factor
				item.EffectType.CLICK_INCOME:
					player_data.coins_per_click += item.effect_factor
