extends Node


enum states {HOME, LOADING, PLAYING, PAUSED, CLEARED}
enum {SMALL, MEDIUM, LARGE}

var state = states.HOME
var size = SMALL
var level_reqs = [0, 25, 50, 100, 200, 400, 800, 1600, 3200, 6400]
#var level_reqs = [0, 1, 2, 3]
var settings = {
	"music" : true,
	"sound" : true}
var data = {
	"solved" : 0,
	"level" : 1}
var current_maze = {
	"exists" : false,
	"cleared" : false,
	"size" : null,
	"seed" : null}

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
	pass


func set_size():
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


func wipe_current_maze():
	current_maze = {
	"exists" : false,
	"cleared" : false,
	"size" : null,
	"seed" : null}


func save_game_data():
	var save = [settings, data, current_maze]
	var data_file = File.new()
	data_file.open("user://data.mal", File.WRITE)
	data_file.store_var(save)
	data_file.close()


func load_game_data():
	var data_file = File.new()
	if  not data_file.file_exists("user://data.mal"):
		return
	data_file.open("user://data.mal", File.READ)
	var save = data_file.get_var()
	settings = save[0]
	data = save[1]
	current_maze = save[2]
	data_file.close()
