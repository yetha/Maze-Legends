extends TextureRect

var tween = Tween.new()
var map_visible = false
var visible_value
var invisible_value

var initial_pos = Vector2(0, 0)
var min_dist = 100

#onready var sound = $SwipeSound


func _ready():
	add_child(tween)


func _notification(what):
	if what == NOTIFICATION_PAUSED:
		hide()
	if what == NOTIFICATION_UNPAUSED:
		show()
	pass


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_DOWN:
			toggle_map(not map_visible)
	if not event is InputEventScreenTouch:
		return
	if event.index != 0:
		return
	if event is InputEventScreenTouch and event.is_pressed():
		initial_pos = event.position
	elif event is InputEventScreenTouch and not event.is_pressed():
		var swipe_vec = event.position - initial_pos
		var vec2_aspct = abs(swipe_vec.aspect())
		if vec2_aspct < 0.5:
			if swipe_vec.y < -min_dist:
				toggle_map(true)
			elif swipe_vec.y > min_dist:
				toggle_map(false)
	pass



func toggle_map(visibility, time=0.5):
	if tween.is_active():
		return
	var new_value = invisible_value
	if visibility:
		new_value = visible_value
	tween.interpolate_property(self, "rect_position:y", null, new_value, time, 5, 1)
	tween.start()
#	sound.play()
