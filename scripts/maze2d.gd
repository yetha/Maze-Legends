extends Node2D

var step = Vector2(50, 50)

onready var hwalls = owner.hwalls
onready var vwalls = owner.vwalls
onready var ovwalls = owner.ovwalls
onready var ohwalls = owner.ohwalls
onready var loctr = $Locator

onready var wall_res = preload("res://wall2d.tscn")


func _ready():
	position = step
	pass


func starting():
	get_parent().size = (owner.maze_width + 2) * step
	build_maze()


func build_maze():
	var harbor = Node2D.new()
	for wall in hwalls + ohwalls:
		var wall_i = wall_res.instance()
		harbor.add_child(wall_i)
		wall_i.position = wall * step
	for wall in vwalls + ovwalls:
		var wall_i = wall_res.instance()
		harbor.add_child(wall_i)
		wall_i.position = wall * step
		wall_i.rotation = PI / 2
	get_child(0).call_deferred("add_child", harbor)


func update_place(cur_coors):
	loctr.position = cur_coors * step + step / 2
	pass

