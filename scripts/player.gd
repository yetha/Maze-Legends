extends Spatial

#var can_turn = false
var tween_going = false
var scnd_ani = false
var scnd_way
var min_dist = 100
var initial_pos = Vector2(0, 0)

enum {FORWARD, LEFT, RIGHT}

onready var tween = $Tween
onready var area = $PArea
onready var map = $"../UI/Map"
#onready var sound = $MvmntSwipe
onready var step = owner.step
onready var path = owner.path


func _ready():
	pass


func starting():
	var maze_width = owner.maze_width
	rotation.y = 0
	translation = Vector3((maze_width / 2 + 0.5) * step, 0, (maze_width + 0.5) * step)
	owner.player_moved(Vector2(translation.x, translation.z))
	set_process_unhandled_input(true)
	tween_going = false
	scnd_ani = false
	tween.stop_all()


func _unhandled_input(event):
	if map.showing:
		return
	if event is InputEventKey:
		if event.pressed:
			var p_key = event.scancode
			if p_key == KEY_UP:
				animate(FORWARD)
			elif p_key == KEY_LEFT:
				animate(LEFT)
			elif p_key == KEY_RIGHT:
				animate(RIGHT)
#	if not event is InputEventScreenTouch:
#		return
#	if event.index != 0:
#		return
#	if event is InputEventScreenTouch and event.is_pressed():
#		initial_pos = event.position
#	elif event is InputEventScreenTouch and not event.is_pressed():
#		var swipe_vec = event.position - initial_pos
#		if abs(swipe_vec.x) < 10 and abs(swipe_vec.y) < 20:
#			animate(FORWARD)
#			return
#		var vec2_aspct = abs(swipe_vec.aspect())
#		if vec2_aspct > 2:
#			if swipe_vec.x > min_dist:
#				animate(RIGHT)
#			elif swipe_vec.x < -min_dist:
#				animate(LEFT)


func can_movef():
	var can_move = true
	if area.get_overlapping_bodies():
		can_move = false
	return can_move


func animate(way):
	if tween_going:
		scnd_ani = true
		scnd_way = way
		return
	var final_val
	var property = "rotation:y"
	match way:
		FORWARD:
			if can_movef():
				final_val = self.translation + Vector3(0, 0, -step).rotated(Vector3(0, 1, 0), rotation.y)
				property = "translation"
				owner.player_moved(Vector2(final_val.x, final_val.z))
		LEFT:
			final_val = self.rotation.y + PI / 2
		RIGHT:
			final_val = self.rotation.y - PI / 2
	if final_val != null:
		tween.interpolate_property(self, property, null, final_val, 0.5, 0, 0)
		tween.start()
		tween_going = true
#		if property == "translation":
#			sound.play()
		scnd_ani = false


func _on_Tween_tween_completed(_object, _key):
	tween_going = false
	if scnd_ani:
		animate(scnd_way)


func _on_Tween_tween_started(_object, _key):
#	tween_going = true
	pass


func _on_Touch_pressed(direction):
#	if map.showing:
#		return
	animate(direction)
	pass # Replace with function body.
