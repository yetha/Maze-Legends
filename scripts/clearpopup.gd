extends PopupPanel

var temp_current_level

onready var tree = get_tree()
onready var title = $VBoxCont/Label
onready var replay = $VBoxCont/VBoxContainer/HBoxContainer/Replay


func _notification(what):
	if what == 6 or what == 7:#MainLoop constants back and quit
		if visible:
			call_deferred("_on_Home_pressed")
			main.call_deferred("_on_Home_pressed")


func _on_level_ended():
	replay.show()
	if owner.try_success:
		if not main.current_level["cleared"]:
			main.data["solves"] += 1
			main.current_level["cleared"] = true
		main.state = main.states.CLEARED
		title.text = "Cleared"
		replay.text = "Replay"
	else:
		if not main.current_level["cleared"]:
			main.current_level["fails"] += 1
			replay.text = "Try again"
			if main.current_level["fails"] > 1:
				replay.hide()
		title.text = "Failed"
	tree.paused = true
	temp_current_level = main.current_level
	main.wipe_current_level()
	main.save_game_data()
	popup_centered()
	pass # Replace with function body.


func _on_Replay_pressed():
	tree.paused = false
	main.state = main.states.PLAYING
	main.current_level = temp_current_level
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
