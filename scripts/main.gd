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
	"solved" : 0,
	"coins" : 0}
var unclrd_level = {
	"exists" : false,
	"solved" : false,
	"size" : null,
	"seed" : null}


onready var maze_scene = preload("res://maze.tscn")


func _ready():
#	randomize()
#	load_game_data()
	pass


func set_size():
	size = SMALL
	pass


func wipe_unclrd_level():
	unclrd_level = {
	"exists" : false,
	"solved" : false,
	"type" : null,
	"size" : null,
	"seed" : null}


func save_game_data():
	return
	var data_file = File.new()
	data_file.open("user://data.brinths", File.WRITE)
	data_file.store_line(to_json(settings))
	data_file.store_line(to_json(data))
	data_file.store_line(to_json(unclrd_level))
	data_file.close()


func load_game_data():
	return
	var data_file = File.new()
	if  not data_file.file_exists("user://data.brinths"):
		return
	data_file.open("user://data.brinths", File.READ)
	settings = parse_json(data_file.get_line())
	data = parse_json(data_file.get_line())
	unclrd_level = parse_json(data_file.get_line())
	data_file.close()
