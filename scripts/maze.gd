extends Spatial

var sizes = [9, 13, 17]
var maze_width = sizes[main.size]
var step = 6
var dirs = [Vector2.UP, Vector2.RIGHT,
			Vector2.DOWN, Vector2.LEFT]
var unvisited = []
var hwalls = []
var vwalls = []
var ohwalls = []
var ovwalls = []
var path = []
var maze_loops = []
var try_success = false
var rng = RandomNumberGenerator.new()
var st_thread = Thread.new()

onready var player = $Player
onready var ground = $Ground
onready var colls = $Colliders
onready var om2d = $MapVP/World2D
onready var line = $MapVP/World2D/Path
onready var fin_area = $Finish
onready var loading_ui = $UI/Loading
onready var map = $UI/Map
onready var timer = $Timer


onready var wall = preload("res://wall.tscn")
#onready var gnd = preload("res://ground.tscn")
#onready var hedge = preload("res://resources/woodblock.mesh")

signal level_loaded
signal level_ended


func _ready():
	loading_ui.show()
	starting(null)
#	st_thread.start(self, "starting", null, 1)
	pass


func starting(_userdata):
	if not main.current_level["exists"]:
		rng.randomize()
		main.current_level["exists"] = true
		main.current_level["seed"] = rng.seed
		main.current_level["size"] = main.size
		main.data["levels"] += 1
	else:
		rng.seed = main.current_level["seed"]
	draw_grid()
	def_maze()
	build_maze()
	timer.wait_time = maze_width * maze_width
	player.starting()
	om2d.starting()
	map.starting()
	call_deferred("join_thread")
	pass


func join_thread():
#	st_thread.wait_to_finish()
	main.save_game_data()
	emit_signal("level_loaded")


func new():
	main.wipe_current_level()
	unvisited.clear()
	hwalls.clear()
	vwalls.clear()
	ohwalls.clear()
	ovwalls.clear()
	path.clear()
	maze_loops.clear()
	try_success = false
	get_child(0).get_child(0).queue_free()
	om2d.get_child(0).get_child(0).queue_free()
	line.get_child(0).stop_all()
	line.points = PoolVector2Array([])
	_ready()
	pass


func restart():
	loading_ui.show()
	path.clear()
	player.starting()
	line.get_child(0).stop_all()
	line.points = PoolVector2Array([])
	try_success = false
	map.starting()
	emit_signal("level_loaded")
	pass


func check_nbrs(cell):
	var nbrs = []
	for dir in dirs:
		if cell + dir in unvisited:
			nbrs.append(cell + dir)
	return nbrs


func draw_grid():
	for x in range(maze_width):
		for y in range(maze_width):
			unvisited.append(Vector2(x, y))
	for x in range(maze_width):
		for y in range(1, maze_width):
			hwalls.append(Vector2(x, y))
	for x in range(1, maze_width):
		for y in range(maze_width):
			vwalls.append(Vector2(x, y))
	for x in range(maze_width):
		ohwalls.append(Vector2(x, 0))
		ohwalls.append(Vector2(x, maze_width))
	ohwalls.erase(Vector2(maze_width / 2, 0))
	ohwalls.erase(Vector2(maze_width / 2, maze_width))
	for y in range(maze_width):
		ovwalls.append(Vector2(0, y))
		ovwalls.append(Vector2(maze_width, y))


func def_maze():
	var current = Vector2(maze_width - 1, maze_width - 1)
	unvisited.erase(current)
	print(current)
	var stack = []
	while not unvisited.empty():
		var nbrs = check_nbrs(current)
		if nbrs.size() > 0:
			var next = nbrs[rng.randi() % nbrs.size()]
			stack.append(current)
			var dir = next - current
			match dir:
				Vector2.UP:
					hwalls.erase(current)
				Vector2.RIGHT:
					vwalls.erase(next)
				Vector2.DOWN:
					hwalls.erase(next)
				Vector2.LEFT:
					vwalls.erase(current)
			current = next
			unvisited.erase(current)
		elif not stack.empty():
			current = stack.pop_back()
	var loops = int(maze_width / 8)
	var wall_arrs = [hwalls, vwalls]
	while loops >= 0:
		var rand_wall_arr = wall_arrs[rng.randi() % 2]
		rand_wall_arr.erase(rand_wall_arr[rng.randi() % rand_wall_arr.size()])
		loops -= 1


func build_maze():
	var maze = Spatial.new()
	ground.translation.x = float(maze_width) / 2 * step
	ground.translation.z = ground.translation.x
	ground.mesh.size.x = (maze_width + 1) * step
	ground.mesh.size.y = ground.mesh.size.x
	for wall_coor in hwalls + ohwalls:
		var wall_i = wall.instance()
		maze.add_child(wall_i)
		wall_i.translation = Vector3(wall_coor.x * step, 0, wall_coor.y * step)
	for wall_coor in vwalls + ovwalls:
		var wall_i = wall.instance()
		maze.add_child(wall_i)
		wall_i.translation = Vector3(wall_coor.x * step, 0, wall_coor.y * step)
		wall_i.rotation.y = -PI / 2
	get_child(0).call_deferred("add_child", maze)
	fin_area.translation = Vector3((maze_width / 2 + 0.5) * step, 1, -0.5 * step)


func build_collis(coors):
	var arr_colls = colls.get_children()
	for wall in [coors, coors + Vector2(0, 1)]:
		if wall in hwalls + ohwalls:
			arr_colls[0].translation = Vector3(wall.x * step, 0, wall.y * step)
			arr_colls[0].rotation.y = 0
			arr_colls.remove(0)
	for wall in [coors, coors + Vector2(1, 0)]:
		if wall in vwalls + ovwalls:
			arr_colls[0].translation = Vector3(wall.x * step, 0, wall.y * step)
			arr_colls[0].rotation.y = -PI / 2
			arr_colls.remove(0)
	for col in arr_colls:
		col.translation.y = -10


func addto_path(coors):
	path.append(coors)
	if path.size() > 2:
		if coors == path[-3]:
#			main.lvl_rtrces += 1
			pass
		elif path.count(coors) > 1:
			if not path.count(path[-2]) > 1:
				if not coors in maze_loops:
					maze_loops.append(coors)
#					main.lvl_loops += 1
				pass


func player_moved(location):
	var coors = Vector2(floor(location.x / step), floor(location.y / step))
	build_collis(coors)
	addto_path(coors)
	om2d.update_place(coors)
	pass


func _on_Finish_area_entered(area):
	if area.name == "PArea":
		yield(get_tree().create_timer(1), "timeout")
		try_success = true
		emit_signal("level_ended")
	pass # Replace with function body.


#func _on_level_loaded():
#	loading_ui.hide()
#	pass # Replace with function body.


func _on_Timer_timeout():
	emit_signal("level_ended")
	pass # Replace with function body.
