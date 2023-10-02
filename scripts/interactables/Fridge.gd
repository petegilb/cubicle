extends Interactable

func get_prompt():
	return 'Press %s to eat your lunch' % InputMap.action_get_events('action_interact')[0].as_text()

func interact(interactor: CharacterBody3D, callback: Callable):
	callback.call("Successfully interacted with the fridge")
	if interactor.get_parent() and interactor.get_parent().has_method('complete_task_type'):
		if last_interacted_time < 0 or (last_interacted_time > 0 and last_interacted_time + timeout_time < interactor.get_parent().get_current_time()):
			last_interacted_time = interactor.get_parent().get_current_time()
			interactor.get_parent().complete_task_type(LunchTask)
		else:
			interactor.get_parent().send_notification("It's too soon to use this again! Wait %d minutes" % last_interacted_time + timeout_time - interactor.get_parent().get_current_time())
