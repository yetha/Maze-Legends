extends PopupPanel

onready var tree = get_tree()
onready var levelui = get_parent()


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
	popup_centered()
	pass # Replace with function body.


func _on_Continue_pressed():
	tree.paused = false
	main.state = main.states.PLAYING
	hide()
	pass # Replace with function body.


func _on_Restart_pressed():
	tree.paused = false
	main.state = main.states.PLAYING
	hide()
	owner.restart()
	pass # Replace with function body.


func _on_Skip_pressed():
	tree.paused = false
	main.state = main.states.PLAYING
	hide()
	main.wipe_unclrd_level()
	owner.new()
	pass # Replace with function body.


func _on_Home_pressed():
	tree.paused = false
	hide()
	pass # Replace with function body.


func _on_Settings_pressed():
	get_parent().move_child(self, 0)
	pass # Replace with function body.
