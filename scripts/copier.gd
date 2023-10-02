extends Interactable

func get_prompt():
	return 'Press %s to make copies' % InputMap.action_get_events('action_interact')[0].as_text()

func interact(interactor: CharacterBody3D, callback: Callable):
	callback.call("Successfully interacted with the copier")
