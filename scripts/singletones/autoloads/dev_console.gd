extends Node

@onready var cursor = $"/root/Game/CanvasLayer/Cursor"


func _ready() -> void:
	Console.add_command('test_console', test_console)
	Console.add_command('save_player_data', save_player_data)
	Console.add_command('show_ui_cursor', show_ui_cursor)
	Console.add_command('show_game_cursor', show_game_cursor)
	

func test_console():
	print('console test')
	Console.print_line('console test')


func save_player_data():
	SaveManager.save_player_data()
	Console.print_line('player data saved with coins: %d' % Globals.player_data.coins)


func show_ui_cursor():
	Console.print_line('cursor mode set to ui')
	cursor.show_ui_cursor()


func show_game_cursor():
	Console.print_line('cursor mode set to game')
	cursor.show_game_cursor()
