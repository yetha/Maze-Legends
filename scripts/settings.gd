extends PopupPanel

onready var music = $VBoxContainer/VBoxContainer/Music
onready var sound = $VBoxContainer/VBoxContainer/Sound


func _ready():
	music.pressed = main.settings["music"]
	sound.pressed = main.settings["sound"]
	pass


func _on_Settings_popup_hide():
	main.settings["music"] = music.pressed
	main.settings["sound"] = sound.pressed
	main.save_game_data()
	pass # Replace with function body.
