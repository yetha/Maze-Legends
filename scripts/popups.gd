extends Control

onready var about = $About
onready var settings = $Settings
onready var tutorial = $Tutorial

onready var popups = [settings, about, tutorial]

# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OK_pressed(popup_index):
	popups[popup_index].hide()
	pass # Replace with function body.


func _on_AboutButton_pressed():
	about.popup_centered()
	pass # Replace with function body.


func _on_HowToPlay_pressed():
	tutorial.popup_centered()
	pass # Replace with function body.
