extends Button

func _on_pressed():
	var root_game_node = get_tree().get_root().get_node('CubicleGame')
	if root_game_node and root_game_node.has_method('get_ui'):
		root_game_node.get_ui().hide_emails()
