extends CanvasLayer
class_name UI

@onready var interact_prompt = $Control/MarginContainer/VBoxContainer/InteractPrompt
@onready var time_label = $Control/TimeMargin/TimeLabel
@onready var emails = $Control/Emails
@onready var approval_label = $Control/ApprovalMargin/ApprovalLabel
@onready var tasks = $Control/Tasks
@onready var notification_label = $Control/NotificationLabel

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
	
func show_tasks():
	show_ui(tasks)
	
func hide_tasks():
	hide_ui(tasks)

func _on_cubicle_game_approval_updated(new_value):
	approval_label.text = new_value

func _on_cubicle_game_on_screen_notification(text, duration=3):
	notification_label.text = text
	notification_label.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(notification_label, "modulate:a", 1, 1)
	tween.tween_callback(func(): await get_tree().create_timer(duration).timeout; var fade_out_tween = get_tree().create_tween(); fade_out_tween.tween_property(notification_label, "modulate:a", 0, 1))

func _on_cubicle_game_update_task_list(task_list):
	tasks.update_tasks(task_list)
