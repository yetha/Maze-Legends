extends Control

onready var achvments = $AchievemntsPopup
onready var settings = $Popups/Settings
onready var quit = $QuitPopup
onready var level = $Level
onready var l = $AchievemntsPopup/VBoxContainer/VBoxContainer/PanelContainer/HBoxContainer/Label


func _ready():
	level.text = "Level " + str(main.data["level"])
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
	l.text = str(main.data["solved"])
	pass # Replace with function body.
