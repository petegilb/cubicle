extends Control

@onready var task_list = $TaskWindowMargin/MarginContainer/TaskList


var DEFAULT_TASKS = ['Answer your Emails', 'Attend your Meetings', 'Brew Coffee', 'Get Lunch', 'Make Copies', 'Drink Water']

func _ready():
	# TODO: remove this quick hack to fix race condition
	await get_tree().create_timer(1).timeout 
	var root_game_node = get_tree().get_root().get_node('CubicleGame')
	if root_game_node:
		for task in root_game_node.get_daily_tasks():
			task_list.add_item(task.get_name(), null, false)


func _on_close_pressed():
	var root_game_node = get_tree().get_root().get_node('CubicleGame')
	if root_game_node and root_game_node.has_method('get_ui'):
		root_game_node.get_ui().hide_tasks()
