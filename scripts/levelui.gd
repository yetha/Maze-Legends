extends Control

onready var tree = get_tree()
onready var pause_button = $HBoxContainer/Pause
onready var map = $Map
onready var map_button = $MapButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_button.hide()
	map.visible_value = map.rect_position.y
	map.invisible_value = map.visible_value + rect_size.y
	pass # Replace with function body.


func _on_Home_pressed():
	tree.paused = false
	tree.change_scene("res://home.tscn")
	pass # Replace with function body.


func _on_maze_loaded():
	$Loading.hide()
	tree.paused = true
	pass # Replace with function body.


func _on_MapButton_pressed():
	pause_button.show()
	pass # Replace with function body.


func _on_maze_ended():
	pause_button.hide()
	map_button.hide()
	pass # Replace with function body.
