extends PopupPanel

onready var tree = get_tree()
onready var button = $"../HBoxContainer/Pause"


func _notification(what):
	if main.state != main.states.PLAYING:
		return
	if what == 1006 or what == 1007:#MainLoop constants back and quit
		if visible:
			call_deferred("_on_Continue_pressed")
		else:
			call_deferred("_on_Pause_pressed")
#	if what == 1004 or what == 1005: #MainLoop constants focus in and out
#			call_deferred("_on_Pause_pressed")
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
	main.state = main.states.PLAYING
	owner.restart()
	hide()
	pass # Replace with function body.
#
#
#func _on_Home_pressed():
#	tree.paused = false
#	hide()
#	pass # Replace with function body.
