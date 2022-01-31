extends Node2D
var alive_duration = 520
var ticker = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if ticker < alive_duration:
		ticker += 1
	else:
		call_deferred("remove_item")

func remove_item():
	get_parent().remove_child(self)		

		
