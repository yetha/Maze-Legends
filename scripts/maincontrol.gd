extends Control

onready var achvments = $AchievemntsPopup
onready var settings = $Popups/Settings
onready var quit = $QuitPopup


func _ready():
	pass # Replace with function body.


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
	var l = $AchievemntsPopup/VBoxContainer/VBoxContainer/PanelContainer/HBoxContainer/Label
	var percent = 0
	l.text = str(main.data["solves"]) + " - "
	if main.data["levels"] > 0:
		percent = stepify(float(main.data["solves"]) / float(main.data["levels"]), 0.01) * 100
	l.text += str(percent) + "%"
	pass # Replace with function body.
