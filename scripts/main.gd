extends Node3D
class_name CubicleMain

func _ready():
	# Temporary limit to 60 fps to stop physics jitter
	Engine.max_fps = 60
	print('The game has begun!')
	start_game()

func start_game():
	pass
