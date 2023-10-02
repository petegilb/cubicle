extends Node3D
class_name Interactable

func get_prompt():
	return 'Press the interact button to interact with me!'

func interact(interactor: CharacterBody3D, callback: Callable):
	callback.call("Successfully interacted")
