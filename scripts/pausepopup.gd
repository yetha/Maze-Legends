extends PopupPanel

onready var tree = get_tree()
onready var button = $"../HBoxContainer/Pause"


func _notification(what):
	if main.state != main.states.PLAYING:
		return
	if what == 6 or what == 7:#MainLoop constants back and quit
		if visible:
			call_deferred("_on_Continue_pressed")
		else:
			call_deferred("_on_Pause_pressed")
	if what == 4 or what == 5: #MainLoop constants focus in and out
			call_deferred("_on_Pause_pressed")
	pass


func _on_Pause_pressed():
	tree.paused = true
	main.state = main.states.PAUSED
	button.hide()
	popup_centered()
	pass # Replace with function body.


func _on_Continue_pressed():
	tree.paused = false
	main.state = main.states.PLAYING
	button.show()
	hide()
	pass # Replace with function body.


func _on_Restart_pressed():
	tree.paused = false
	main.current_level["fails"] += 1
	main.state = main.states.PLAYING
	owner.restart()
	hide()
	pass # Replace with function body.


func _on_Skip_pressed():
	tree.paused = false
	main.state = main.states.PLAYING
	owner.new()
	hide()
	pass # Replace with function body.
#
#
#func _on_Home_pressed():
#	tree.paused = false
#	hide()
#	pass # Replace with function body.


func _on_Settings_pressed():
	get_parent().move_child(self, 0)
	pass # Replace with function body.
