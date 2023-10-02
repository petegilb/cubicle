extends Node3D
class_name CubicleMain

const DAY_LENGTH_IN_SECONDS = 60*8

@onready var day_timer = $DayTimer
@onready var second_timer = $SecondTimer

signal day_clock_updated(new_time)

func _ready():
	# Temporary limit to 60 fps to stop physics jitter
	Engine.max_fps = 60
	start_game()

func _process(_delta):
	get_clock_time()
	pass

func start_game():
	print('The game has begun!')
	day_timer.wait_time = DAY_LENGTH_IN_SECONDS
	day_timer.start()
	second_timer.start()

func _on_day_timer_timeout():
	print('The day has ended...')
	
func _on_second_timer_timeout():
	day_clock_updated.emit(get_clock_time())

func get_clock_time():
	# Assuming each second will act as a "minute"
	var remaining_hours = day_timer.time_left / 60
	# we start at 9am everyday and go until 5pm
	var current_hour = 17 - remaining_hours
	var current_hour_12 = current_hour - 12 if current_hour > 12 else current_hour
	var current_minutes = 60 - fmod(day_timer.time_left, 60)
	var am_or_pm = "pm" if current_hour > 12 else "am"
	return "%02d:%02d%s" % [current_hour_12, current_minutes, am_or_pm]
