extends PopupPanel

onready var ads = $VBoxContainer/VBoxContainer/Ads
onready var music = $VBoxContainer/VBoxContainer/Music
onready var sound = $VBoxContainer/VBoxContainer/Sound


func _ready():
	ads.pressed = main.settings["ads"]
	music.pressed = main.settings["music"]
	sound.pressed = main.settings["sound"]
	pass


func _on_SettingsPopup_popup_hide():
	main.settings["ads"] = ads.pressed
	main.settings["music"] = music.pressed
	main.settings["sound"] = sound.pressed
#	main.save_game_data()
	pass

