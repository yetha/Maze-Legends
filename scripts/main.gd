extends Node


enum states {HOME, LOADING, PLAYING, PAUSED, CLEARED}
enum {SMALL, MEDIUM, LARGE}

var state = states.HOME
var size = SMALL
var settings = {
	"ads" : true,
	"music" : true,
	"sound" : true}
var data = {
	"levels" : 0,
	"solves" : 0}
var current_level = {
	"exists" : false,
	"cleared" : false,
	"size" : null,
	"seed" : null,
	"fails" : 0}


onready var maze_scene = preload("res://maze.tscn")


func _ready():
	load_game_data()
	set_size()
	pass


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_G and event.pressed:
			print(settings, data, current_level)
		if event.scancode == KEY_B and event.pressed:
			set_size()
	pass


func set_size():
	if current_level["exists"]:
		size = current_level["size"]
	else:
		size = SMALL
	pass


func wipe_current_level():
	current_level = {
	"exists" : false,
	"cleared" : false,
	"size" : null,
	"seed" : null,
	"fails" : 0}


func save_game_data():
	var save = [settings, data, current_level]
	var data_file = File.new()
	data_file.open("user://data.mal", File.WRITE)
	data_file.store_var(save)
#	data_file.store_line(to_json(settings))
#	data_file.store_line(to_json(data))
#	data_file.store_line(to_json(current_level))
	data_file.close()


func load_game_data():
	var data_file = File.new()
	if  not data_file.file_exists("user://data.mal"):
		return
	data_file.open("user://data.mal", File.READ)
	var save = data_file.get_var()
	settings = save[0]#parse_json(data_file.get_line())
	data = save[1]#parse_json(data_file.get_line())
#	var line = data_file.get_line()
	current_level = save[2]#parse_json(line)
#	print(line)
	data_file.close()
