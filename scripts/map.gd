extends TextureRect

var tween = Tween.new()
var b_timer = Timer.new()
var showing = true
var visible_value
var invisible_value

onready var tree = get_tree()
onready var button = get_node("../MapButton")

#onready var sound = $SwipeSound


func _ready():
	add_child(tween)
	add_child(b_timer)
	b_timer.one_shot = true
	b_timer.pause_mode = PAUSE_MODE_STOP
	b_timer.connect("timeout", self, "_on_timer_timeout")
	pass


func _process(_delta):
	if button.disabled:
		button.text = "MAP (" + str(int(b_timer.time_left)) + ")"
	pass


func starting():
	rect_position.y = visible_value
	showing = true
	b_timer.stop()
	b_timer.wait_time = 7.5
	button.disabled = false
	button.text = "START"
	button.show()
	button.connect("pressed", get_parent(),"_on_MapButton_pressed", [], 4)


func toggle_map():
	if tween.is_active():
		return
	var value = visible_value
	if showing:
		value = invisible_value
		button.disabled = true
		b_timer.start()
	showing = not showing
	tween.interpolate_property(self, "rect_position:y", null, value, 0.5, 5, 1)
	tween.start()
#	sound.play()


func _on_MapButton_pressed():
	tree.paused = false
	toggle_map()
	button.text = "MAP"
	main.state = main.states.PLAYING


func _on_timer_timeout():
	button.disabled = false
	button.text = "MAP"
	pass


func _on_PausePopup_about_to_show():
	hide()
	button.hide()
	pass # Replace with function body.


func _on_PausePopup_popup_hide():
	show()
	button.show()
	pass # Replace with function body.
