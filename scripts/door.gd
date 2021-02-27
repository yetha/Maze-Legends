extends Spatial


onready var anim_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func open():
	anim_player.play("opening")
	pass


func close():
	anim_player.play_backwards("opening")
	pass
	
