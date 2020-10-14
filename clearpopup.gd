extends PopupPanel

var temp_unclrd_level

onready var tree = get_tree()
onready var levelui = get_parent()


func _notification(what):
	if what == 6 or what == 7:#MainLoop constants back and quit
		if visible:
			call_deferred("_on_Home_pressed")
			main.call_deferred("_on_Home_pressed")


func _on_level_cleared():
	if not main.unclrd_level["solved"]:
		main.unclrd_level["solved"] = true
		main.data["solved"] += 1
	temp_unclrd_level = main.unclrd_level
	main.wipe_unclrd_level()
	main.save_game_data()
	tree.paused = true
	main.state = main.states.CLEARED
	popup_centered()
	pass


func _on_Replay_pressed():
	tree.paused = false
	main.state = main.states.PLAYING
	main.unclrd_level = temp_unclrd_level
	main.save_game_data()
	owner.restart()
	hide()
	pass # Replace with function body.


func _on_Home_pressed():
	tree.paused = false
	hide()
	pass # Replace with function body.


func _on_Next_pressed():
	tree.paused = false
	main.state = main.states.PLAYING
	hide()
	owner.new()
	pass # Replace with function body.
