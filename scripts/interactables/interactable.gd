extends Node3D
class_name Interactable

# how long to time out before the player can interact again
@export var timeout_time = 10
var last_interacted_time = -1

func get_prompt():
	return 'Press the interact button to interact with me!'

func interact(interactor: CharacterBody3D, callback: Callable):
	callback.call("Successfully interacted")
