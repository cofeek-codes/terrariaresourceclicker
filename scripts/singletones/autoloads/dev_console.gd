extends Node

func _ready() -> void:
	Console.add_command('test_console', test_console)

func test_console():
	print('console test')
	Console.print_line('console test')
