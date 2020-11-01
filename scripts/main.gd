extends Node


enum states {HOME, LOADING, PLAYING, PAUSED, CLEARED}
enum {SMALL, MEDIUM, LARGE}

var state = states.HOME
var size = SMALL
var level_reqs = [0, 25, 50, 100, 200, 400, 800, 1600, 3200, 6400]
#var level_reqs = [0, 1, 2, 3]
var settings = {
	"ads" : true,
	"music" : true,
	"sound" : true}
var data = {
	"tried" : 0,
	"solved" : 0,
	"level" : 1}
var current_maze = {
	"exists" : false,
	"cleared" : false,
	"size" : null,
	"seed" : null,
	"fails" : 0}

onready var maze_scene = preload("res://maze.tscn")


func _ready():
	load_game_data()
	save_game_data()
	set_size()
	pass


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_G and event.pressed:
			print(settings, data, current_maze)
		if event.scancode == KEY_B and event.pressed:
			set_size()
#		if event.scancode == KEY_X and event.pressed:
#			data["solved"] += 25
#			print("Solved = ", data["solved"])
#		if event.scancode == KEY_Y and event.pressed:
#			level_up()
	pass


func set_size():
	if false:#current_maze["exists"]:
		size = current_maze["size"]
	else:
		size = 7 + (data["level"] * 2)
	pass


func progression():
	if data["level"] == level_reqs.size():
		return
	var up_req = 0
	for n in range(data["level"] + 1):
		up_req = up_req + level_reqs[n]
	var needed = level_reqs[data["level"]]
	var managed = needed - (up_req - data["solved"])
	if needed == managed:
		data["level"] += 1
		set_size()
	return Vector2(managed, needed)
#	print("got, needed: ", Vector2(managed, needed))
#	print("Level = ", data["level"], ", req ", up_req)
	pass


func wipe_current_maze():
	current_maze = {
	"exists" : false,
	"cleared" : false,
	"size" : null,
	"seed" : null,
	"fails" : 0}


func save_game_data():
	var save = [settings, data, current_maze]
	var data_file = File.new()
	data_file.open("user://data.mal", File.WRITE)
	data_file.store_var(save)
#	data_file.store_line(to_json(settings))
#	data_file.store_line(to_json(data))
#	data_file.store_line(to_json(current_maze))
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
	current_maze = save[2]#parse_json(line)
	print("Save: ", save)
	data_file.close()
