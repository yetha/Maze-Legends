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
	loctr.hide()
	pass


func starting():
	get_parent().size = (owner.maze_width + 2) * step
	build_maze()


func build_maze():
	var harbor = Node2D.new()
	for wall in hwalls + ohwalls + owner.harcs:
		var wall_i = wall_res.instance()
		harbor.add_child(wall_i)
		wall_i.position = wall * step
		if wall in owner.harcs:
			wall_i.scale.y = 0.3
			harbor.remove_child(wall_i)
	for wall in vwalls + ovwalls + owner.varcs:
		var wall_i = wall_res.instance()
		harbor.add_child(wall_i)
		wall_i.position = wall * step
		wall_i.rotation = PI / 2
		if wall in owner.varcs:
			wall_i.scale.y = 0.3
			harbor.remove_child(wall_i)
	get_child(0).call_deferred("add_child", harbor)


func update_place(cur_coors):
	loctr.position = cur_coors * step + step / 2
	pass

