extends Interactable

func get_prompt():
	return 'Press %s to login to your computer' % InputMap.action_get_events('action_interact')[0].as_text()

func interact(callback: Callable):
	callback.call("Successfully interacted with the computer")
