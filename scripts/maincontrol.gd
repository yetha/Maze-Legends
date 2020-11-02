extends Control

onready var achvments = $AchievemntsPopup
onready var settings = $Popups/Settings
onready var quit = $QuitPopup
onready var s = $AchievemntsPopup/VBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/Solves
onready var l = $AchievemntsPopup/VBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/Level
onready var p = $AchievemntsPopup/VBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/Progress


func _ready():
	print(OS.get_screen_dpi(), " DPI")
	pass # Replace with function body.


func _notification(what):
	if what == 1006 or what == 1007:#MainLoop constants back and quit
			call_deferred("_on_Quit_pressed")


func _on_Play_pressed():
	get_tree().change_scene("res://maze.tscn")
	pass # Replace with function body.


func _on_Achievements_pressed():
	achvments.popup_centered()
	pass # Replace with function body.


func _on_Settings_pressed():
	settings.popup_centered()
	pass # Replace with function body.


func _on_Quit_pressed():
	quit.popup_centered()
	pass # Replace with function body.


func _on_Cancel_pressed():
	quit.hide()
	pass # Replace with function body.


func _on_Confirm_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_Ach_OK_pressed():
	achvments.hide()
	pass # Replace with function body.


func _on_Ach_about_to_show():
	var progress = main.progression()
	if progress != null:
		p.max_value = progress.y
		p.value = progress.x
	s.text = str(main.data["solved"])
	l.text = "Lv" + str(main.data["level"])
	pass # Replace with function body.
