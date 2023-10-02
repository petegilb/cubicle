extends Node3D
class_name CubicleMain

const DAY_LENGTH_IN_SECONDS = 60*8

# This is the player's approval rating that will signify if they've won or lost
var approval_rating = 100
var daily_tasks = []

@onready var day_timer = $DayTimer
@onready var second_timer = $SecondTimer
@onready var ui = $UI
@onready var daily_tasks_node = $DailyTasks

signal day_clock_updated(new_time)
signal approval_updated(new_value)
signal on_screen_notification(text)

func _ready():
	# Temporary limit to 60 fps to stop physics jitter
	Engine.max_fps = 60
	for task in daily_tasks_node.get_children():
		daily_tasks.append(task)
	start_game()

func _process(_delta):
	pass

func start_game():
	print('The game has begun!')
	day_timer.wait_time = DAY_LENGTH_IN_SECONDS
	day_timer.start()
	second_timer.start()
	on_screen_notification.emit('Welcome to work! Try not to get Fired!')
	update_approval(0)

func _on_day_timer_timeout():
	second_timer.stop()
	print('Game Win!')
	on_screen_notification.emit('You win! You made it through the day!')
	await get_tree().create_timer(4).timeout
	on_screen_notification.emit('Restarting game...')
	await get_tree().create_timer(3).timeout
	print(get_tree().reload_current_scene())
	
func _on_second_timer_timeout():
	day_clock_updated.emit(get_clock_time())
	if(approval_rating < 1):
		game_over()
	
	# Check for missed tasks
	for task in daily_tasks:
		# print('%d, %d, %d' % [task.deadline_in_seconds, 17*60 - day_timer.time_left, approval_rating])
		if task.deadline_in_seconds > 0 and task.deadline_in_seconds < 17*60 - day_timer.time_left:
			update_approval(task.approval_change)
			daily_tasks.erase(task)
			on_screen_notification.emit('failed task of type %s' % task.get_name())
			print('failed task of type %s' % task.get_name())

func get_clock_time():
	# Assuming each second will act as a "minute"
	var remaining_hours = day_timer.time_left / 60
	# we start at 9am everyday and go until 5pm
	var current_hour = 17 - remaining_hours
	var current_hour_12 = current_hour - 12 if current_hour > 12 else current_hour
	var current_minutes = 60 - fmod(day_timer.time_left, 60)
	var am_or_pm = "pm" if current_hour > 12 else "am"
	return "%02d:%02d%s" % [current_hour_12, current_minutes, am_or_pm]

func get_ui():
	return ui

func get_daily_tasks():
	return daily_tasks

func update_approval(new_value):
	approval_rating += new_value
	approval_updated.emit('Approval: %d' % approval_rating)

func game_over():
	second_timer.stop()
	print('Game Over!')
	on_screen_notification.emit('Game over, you are FIRED!')
	await get_tree().create_timer(4).timeout
	on_screen_notification.emit('Restarting game...')
	await get_tree().create_timer(3).timeout
	print(get_tree().reload_current_scene())
