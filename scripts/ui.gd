extends CanvasLayer
class_name UI

@onready var interact_prompt = $Control/MarginContainer/VBoxContainer/InteractPrompt
@onready var time_label = $Control/TimeMargin/TimeLabel

func _on_interact_prompt_changed(new_value):
	interact_prompt.text = new_value

func _on_cubicle_game_day_clock_updated(new_time):
	time_label.text = new_time
