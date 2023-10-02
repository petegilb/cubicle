extends CanvasLayer
class_name UI

@onready var interact_prompt = $Control/MarginContainer/VBoxContainer/InteractPrompt
@onready var time_label = $Control/TimeMargin/TimeLabel
@onready var emails = $Control/Emails

func _on_interact_prompt_changed(new_value):
	interact_prompt.text = new_value

func _on_cubicle_game_day_clock_updated(new_time):
	time_label.text = new_time

func show_ui(menu: Control):
	menu.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func hide_ui(menu: Control):
	menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func show_emails():
	show_ui(emails)
	
func hide_emails():
	hide_ui(emails)
