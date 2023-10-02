extends Control

@onready var task_list = $TaskWindowMargin/MarginContainer/TaskList


var DEFAULT_TASKS = ['Answer your Emails', 'Attend your Meetings', 'Brew Coffee', 'Get Lunch', 'Make Copies', 'Drink Water']
const DEFAULT_TASK = 'Tasks (Press Tab to reopen)'

func _ready():
	pass

func _on_close_pressed():
	var root_game_node = get_tree().get_root().get_node('CubicleGame')
	if root_game_node and root_game_node.has_method('get_ui'):
		root_game_node.get_ui().hide_tasks()

func update_tasks(daily_task_list):
	task_list.clear()
	task_list.add_item(DEFAULT_TASK, null, false)
	for task in daily_task_list:
		if task.deadline_leeway > 0:
			task_list.add_item("%s (complete up to %dmin before)" % [task.get_name(), task.deadline_leeway], null, false)
		else:
			task_list.add_item("%s (anytime)" % task.get_name(), null, false)
