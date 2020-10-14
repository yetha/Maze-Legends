extends Control


onready var settings = $Popups/Settings
onready var map = $Map


# Called when the node enters the scene tree for the first time.
func _ready():
	map.visible_value = map.rect_position.y
	map.invisible_value = map.rect_position.y + rect_size.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Home_pressed():
	get_tree().change_scene("res://home.tscn")
	pass # Replace with function body.


func _on_Settings_pressed():
	settings.popup_centered()
	pass # Replace with function body.


func _on_level_loaded():
	map.toggle_map(false, 0)
	$Loading.hide()
	pass # Replace with function body.
