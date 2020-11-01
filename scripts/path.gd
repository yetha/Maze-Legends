extends Line2D

var prev_idx = 0
var part
var path_size

onready var direct_path = owner.path
onready var step = get_parent().step
onready var tween = $Tween


func draw_path():
	prev_idx = 0
	path_size = direct_path.size()
	part = 1.0 / path_size
	tween.interpolate_method(self, "move_path", 0, 1, 3.0, 1, 2)
	tween.start()


func move_path(value):
	var idx = int(value / part)
	if idx == prev_idx:
		if idx > 0 and idx < path_size:
			var remain = fmod(value, part) / part
			var point = lerp(direct_path[idx - 1], direct_path[idx], remain)
			var new_point = (point * step) + (0.5 * step)
			var last_point = get_point_count() - 1
			set_point_position(last_point, new_point)
	else:
		var point = direct_path[prev_idx]
		var new_point = (point * step) + (0.5 * step)
		add_point(new_point)
		if idx < path_size: add_point(new_point)
	prev_idx = idx


func _on_maze_ended():
	draw_path()
	pass # Replace with function body.
