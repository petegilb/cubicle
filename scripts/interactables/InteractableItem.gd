extends Interactable
class_name InteractableItem

@export var prompt = "to make copies"
var task_type

func get_prompt():
	return 'Press %s %s' % [InputMap.action_get_events('action_interact')[0].as_text(), prompt]

func interact(interactor: CharacterBody3D, callback: Callable):
	callback.call("Successfully interacted with the copier")
	if interactor.get_parent() and interactor.get_parent().has_method('complete_task_type'):
		if last_interacted_time < 0 or (last_interacted_time > 0 and last_interacted_time + timeout_time < interactor.get_parent().get_current_time()):
			last_interacted_time = interactor.get_parent().get_current_time()
			interactor.get_parent().complete_task_type(task_type)
		else:
			var until_time = last_interacted_time + timeout_time - interactor.get_parent().get_current_time()
			interactor.get_parent().send_notification("It's too soon to use this again! Wait %d minutes" % until_time)
