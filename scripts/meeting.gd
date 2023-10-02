extends Interactable

func get_prompt():
	return 'Press %s to attend your meeting' % InputMap.action_get_events('action_interact')[0].as_text()

func interact(interactor: CharacterBody3D, callback: Callable):
	callback.call("Successfully interacted with the meeting board")
