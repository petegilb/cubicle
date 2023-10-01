extends CanvasLayer
class_name UI

@onready var interact_prompt = $Control/MarginContainer/VBoxContainer/InteractPrompt

func _on_interact_prompt_changed(new_value):
	interact_prompt.text = new_value
