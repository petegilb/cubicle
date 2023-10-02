extends Interactable

func get_prompt():
	return 'Press %s to open up your tasks for the day' % InputMap.action_get_events('action_interact')[0].as_text()

func interact(interactor: CharacterBody3D, callback: Callable):
	callback.call("Successfully interacted with the notebook")
	var ui = interactor.get_ui()
	ui.show_tasks()
