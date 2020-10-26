extends Control

onready var tree = get_tree()
onready var pause_button = $HBoxContainer/Pause
onready var settings = $Popups/Settings
onready var map = $Map
onready var map_button = $MapButton
onready var timer = $"../Timer"
onready var label = $HBoxContainer/Time


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_button.hide()
	map.visible_value = map.rect_position.y
	map.invisible_value = map.visible_value + rect_size.y
	pass # Replace with function body.


func _process(_delta):
	label.text = str(int(timer.time_left))
	pass


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_S and event.pressed:
			timer.stop()
			timer.wait_time = 5
			timer.start()
	pass


func _on_Home_pressed():
	tree.paused = false
	tree.change_scene("res://home.tscn")
	pass # Replace with function body.


func _on_Settings_pressed():
	settings.popup_centered()
	pass # Replace with function body.


func _on_level_loaded():
	$Loading.hide()
	tree.paused = true
	pass # Replace with function body.


func _on_MapButton_pressed():
	pause_button.show()
	timer.start()
	pass # Replace with function body.


func _on_level_ended():
	pause_button.hide()
	map_button.hide()
	pass # Replace with function body.
