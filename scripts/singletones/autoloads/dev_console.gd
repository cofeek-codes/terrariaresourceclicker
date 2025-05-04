extends Node

func _ready() -> void:
	Console.add_command('test_console', test_console)
	Console.add_command('save_player_data', save_player_data)

func test_console():
	print('console test')
	Console.print_line('console test')

func save_player_data():
	SaveManager.save_player_data()
	Console.print_line('player data saved with coins: %d' % Globals.player_data.coins)
