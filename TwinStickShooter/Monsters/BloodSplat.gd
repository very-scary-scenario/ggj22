extends Node2D
var velocity = Vector2(0,0)
var fade_speed = 0.1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	global_position += velocity
	modulate.a -= fade_speed
	if modulate.a <= 0:
		call_deferred("remove_item")

func remove_item():
	get_parent().remove_child(self)		


func random_frame(num):
	$Sprite.frame = num
