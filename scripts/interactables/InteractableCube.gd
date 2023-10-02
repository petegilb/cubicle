extends Interactable

func get_prompt():
	return 'Press F to send me up into the air!'

func interact(interactor: CharacterBody3D, callback: Callable):
	callback.call("Successfully interacted with the cube")
	position.y += 2
