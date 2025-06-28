extends PanelContainer

@onready var player_data: PlayerData = Globals.get_player_data()

@export var item: ShopItem

@onready var item_image: TextureRect = %ItemImage
@onready var item_title_label: Label = %ItemTitleLabel
@onready var item_price_label: Label = %ItemPriceLabel
@onready var buy_button: Button = %BuyButton

@onready var buy_audio_player: AudioStreamPlayer = $BuyAudioPlayer

@onready var game: Node2D = $"/root/Game"
@onready var buffs: Control = $"/root/Game/CanvasLayer/GameUI/Buffs"

func _ready() -> void:
	item_image.texture = item.texture
	item_title_label.text = item.title
	item_price_label.text = str(item.price)
	buy_button.tooltip_text = item.get_description()
	
func _process(delta: float) -> void:
	if player_data.coins < item.price:
		buy_button.disabled = true
	else:
		buy_button.disabled = false
		

func _on_buy_button_pressed() -> void:
	buy_item()


func buy_item():
	# @NOTE: ill keep buff apply logic here for now
	player_data.coins -= item.price
	buy_audio_player.play()
	add_active_item(item)
	

func add_active_item(item: ShopItem):
	var existing_item_idx = player_data.active_items.find_custom((func(i: ActiveItem): return i.item == item).bind())
	if existing_item_idx != -1:
		player_data.active_items[existing_item_idx].amount += 1
	else:
		var new_item = ActiveItem.new()
		new_item.item = item
		new_item.amount = 1
		player_data.active_items.push_back(new_item)
		
		# introduce new pickaxe
		if item.type == ShopItem.ItemType.PICKAXE:
			player_data.tier += 1
			game.emit_signal('introduce_pickaxe', item.texture)
		if item.type == ShopItem.ItemType.BUFF:
			buffs.emit_signal('buff_added', item)
	
	apply_new_item_stats(item)

func apply_new_item_stats(item: ShopItem):
	print('about to apply item stats for item: %s' % item.title)
	match item.type:
		item.ItemType.PICKAXE:
			print('applying stats for new pickaxe: %s' % item.title)
		item.ItemType.BUFF:
			print('applying stats for new buff: %s' % item.title)
			
	match item.effect_type:
		item.EffectType.TIME_INCOME:
			player_data.coins_per_second += item.effect_factor
		item.EffectType.CLICK_INCOME:
			player_data.coins_per_click += item.effect_factor
