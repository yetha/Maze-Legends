extends Spatial

var sizes = [9, 13, 17]
var maze_width = main.size
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
var rng = RandomNumberGenerator.new()
var st_thread = Thread.new()

var harcs = []
var varcs = []

onready var player = $Player
#onready var ground = $Ground
onready var colls = $Colliders
onready var om2d = $MapVP/World2D
onready var line = $MapVP/World2D/Path
onready var loading_ui = $UI/Loading
onready var map = $UI/Map
onready var door1 = $Door
onready var door2 = $Door2


onready var wall = preload("res://wall.tscn")
onready var column = preload("res://column.tscn")
onready var arc = preload("res://arch.tscn")
onready var ground = preload("res://ground.tscn")
#onready var hedge = preload("res://resources/woodblock.mesh")

signal maze_loaded
signal maze_ended


func _ready():
	maze_width = main.size
	loading_ui.show()
	door1.show()
	door2.show()
#	starting(null)
	st_thread.start(self, "starting", null, 1)
	pass


func starting(_userdata):
	if not main.current_maze["exists"]:
		rng.randomize()
		main.current_maze["exists"] = true
		main.current_maze["seed"] = rng.seed
		main.current_maze["size"] = main.size
	else:
		rng.seed = main.current_maze["seed"]
	draw_grid()
	def_maze()
	build_maze()
	player.starting()
	om2d.starting()
	map.starting()
	call_deferred("join_thread")
	pass


func join_thread():
	st_thread.wait_to_finish()
	main.save_game_data()
	emit_signal("maze_loaded")


func new():
	main.wipe_current_maze()
	unvisited.clear()
	hwalls.clear()
	vwalls.clear()
	ohwalls.clear()
	ovwalls.clear()
	harcs.clear()
	varcs.clear()
	path.clear()
	maze_loops.clear()
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
	map.starting()
	emit_signal("maze_loaded")
	pass


func check_nbrs(cell):
	var nbrs = []
	for dir in dirs:
		if cell + dir in unvisited:
			nbrs.append(cell + dir)
	return nbrs


func is_linked(wall_v, orientaton):
	var connections = 0
	match orientaton:
		"h":
			if (wall_v + Vector2(-1, 0) in hwalls + ohwalls
			or wall_v + Vector2(0 ,-1) in vwalls + ovwalls
			or wall_v in vwalls + ovwalls):
				connections += 1
			if (wall_v + Vector2(1, 0) in hwalls + ohwalls
			or wall_v + Vector2(1 ,0) in vwalls + ovwalls
			or wall_v + Vector2(1 ,-1) in (vwalls + ovwalls)):
				connections += 1
			pass
		"v":
			if (wall_v + Vector2(0, -1) in vwalls + ovwalls
			or wall_v + Vector2(-1 ,0) in hwalls + ohwalls
			or wall_v in hwalls + ohwalls):
				connections += 1
			if (wall_v + Vector2(0, 1) in vwalls + ovwalls
			or wall_v + Vector2(0 ,1) in hwalls + ohwalls
			or wall_v + Vector2(-1 ,1) in (hwalls + ohwalls)):
				connections += 1
			pass
	if connections > 1:
		return true
	pass


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
	var current = Vector2(randi() % maze_width, randi() % maze_width)
	unvisited.erase(current)
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
	var loops = round((hwalls + vwalls).size() * 0.05)
	var wall_arrs = [hwalls, vwalls]
	var arcs_arrs = [harcs, varcs]
	var ori_arrs = ["h","v"]
#	print("LOOPS: ",loops)
	while loops > 0:
		var rand_id = rng.randi() % 2
		var rand_arr = wall_arrs[rand_id]
		var rand_wall = rand_arr[rng.randi() % rand_arr.size()]
		if is_linked(rand_wall, ori_arrs[rand_id]):
			rand_arr.erase(rand_wall)
			arcs_arrs[rand_id].append(rand_wall)
			loops -= 1


func build_maze():
	var maze = Spatial.new()
#	ground.translation.x = float(maze_width) / 2 * step
#	ground.translation.z = ground.translation.x
#	ground.mesh.size.x = (maze_width + 1) * step
#	ground.mesh.size.y = ground.mesh.size.x
	for x in range(-1 , maze_width):
		for y in range(-1 , maze_width):
			var ground_i = ground.instance()
			maze.add_child(ground_i)
			ground_i.translation = Vector3(x * step, 0, y * step)
	for x in maze_width + 1:
		for y in maze_width + 1:
			if not Vector2(x, y) in [Vector2(maze_width/2,0), Vector2((maze_width/2)+1,0), 
			Vector2(maze_width/2,maze_width), Vector2((maze_width/2)+1,maze_width)]:
				var column_i = column.instance()
				maze.add_child(column_i)
				column_i.translation = Vector3(x * step, 0, y * step)
	for wall_coor in hwalls + ohwalls:
		var wall_i = wall.instance()
		maze.add_child(wall_i)
		wall_i.translation = Vector3(wall_coor.x * step, 0, wall_coor.y * step)
	for wall_coor in vwalls + ovwalls:
		var wall_i = wall.instance()
		maze.add_child(wall_i)
		wall_i.translation = Vector3(wall_coor.x * step, 0, wall_coor.y * step)
		wall_i.rotation.y = -PI / 2
	for arc_coor in harcs:
		var arc_i = arc.instance()
		maze.add_child(arc_i)
		arc_i.translation = Vector3(arc_coor.x * step, 0, arc_coor.y * step)
	for arc_coor in varcs:
		var arc_i = arc.instance()
		maze.add_child(arc_i)
		arc_i.translation = Vector3(arc_coor.x * step, 0, arc_coor.y * step)
		arc_i.rotation.y = -PI / 2
	get_child(0).call_deferred("add_child", maze)
	door1.translation = Vector3((maze_width / 2 + 0.5) * step, 0, maze_width * step)
	door2.translation = Vector3((maze_width / 2 + 0.5) * step, 0, 0)


func build_collis(coors):
	pass
#	var arr_colls = colls.get_children()
#	for wall in [coors, coors + Vector2(0, 1)]:
#		if wall in hwalls + ohwalls:
#			arr_colls[0].translation = Vector3(wall.x * step, 0, wall.y * step)
#			arr_colls[0].rotation.y = 0
#			arr_colls.remove(0)
#	for wall in [coors, coors + Vector2(1, 0)]:
#		if wall in vwalls + ovwalls:
#			arr_colls[0].translation = Vector3(wall.x * step, 0, wall.y * step)
#			arr_colls[0].rotation.y = -PI / 2
#			arr_colls.remove(0)
#	for col in arr_colls:
#		col.translation.y = -10


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
	map.update_moves()
	pass


func start_game():
	door1.open()
	yield(get_tree().create_timer(2), "timeout")
	player.animate(0)
#	door1.close()
#	door1.get_node("StaticBody/CollisionShape").disabled = false
	player.set_process_unhandled_input(true)
	pass


func _on_Finish_area_entered(area):
	player.set_process_unhandled_input(false)
	player.scnd_ani = false
	if area.name == "PArea":
		door2.open()
		yield(get_tree().create_timer(2), "timeout")
		player.animate(0)
		yield(get_tree().create_timer(1), "timeout")
#		emit_signal("maze_ended")
	pass # Replace with function body.


#func _on_maze_loaded():
#	loading_ui.hide()
#	pass # Replace with function body.
