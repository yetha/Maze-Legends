extends PopupPanel

onready var tree = get_tree()
onready var level_ui = get_parent()


func _notification(what):
	if what == 1006 or what == 1007:#MainLoop constants back and quit
		if visible:
			level_ui.call_deferred("_on_Home_pressed")


func _on_maze_ended():
	main.data["solved"] += 1
	main.current_maze["cleared"] = true
	main.progression()
	main.state = main.states.CLEARED
	tree.paused = true
	main.wipe_current_maze()
	main.save_game_data()
	popup_centered()
	pass # Replace with function body.


func _on_Replay_pressed():
	tree.paused = false
	main.state = main.states.PLAYING
	main.save_game_data()
	owner.restart()
	hide()
	pass # Replace with function body.
#
#
#func _on_Home_pressed():
#	tree.paused = false
#	hide()
#	pass # Replace with function body.


func _on_Next_pressed():
	tree.paused = false
	main.state = main.states.PLAYING
	owner.new()
	hide()
	pass # Replace with function body.
