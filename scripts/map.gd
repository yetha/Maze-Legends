extends TextureRect

var tween = Tween.new()
var showing = true
var req_mvs = 5.0
var moves = 0
var opp = -3
var visible_value
var invisible_value

onready var path = owner.path
onready var tree = get_tree()
onready var button = $"../MapButton"
onready var inputs = $"../MarginContainer"

#onready var sound = $SwipeSound


func _ready():
	add_child(tween)
	pass


func _process(_delta):
	if button.disabled:
#		button.text = "MAP (" + str(round((float(moves) / req_mvs) * 100)) + "%)"
		if moves >= req_mvs:
			button.disabled = false
			button.text = "MAP"
		button.text = "MAP (" + str(moves) + ")"
	pass


func starting():
	rect_position.y = visible_value
	showing = true
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
		moves = 0
		button.disabled = true
	inputs.visible = showing
	showing = not showing
	tween.interpolate_property(self, "rect_position:y", null, value, 0.5, 5, 1)
	tween.start()
#	sound.play()


func update_moves():
	if moves >= req_mvs:
		return
	if path.size() > -(opp + 1) and path[opp] == path[-1] and moves > 0:
		moves -= 1
		opp -= 2
	else:
		moves += 1
		opp = -3


func _on_MapButton_pressed():
	tree.paused = false
	toggle_map()
	if button.text == "START":
		owner.start_game()
		pass
	button.text = "MAP"
	main.state = main.states.PLAYING


func _on_PausePopup_about_to_show():
	hide()
	button.hide()
	pass # Replace with function body.


func _on_PausePopup_popup_hide():
	show()
	button.show()
	pass # Replace with function body.
