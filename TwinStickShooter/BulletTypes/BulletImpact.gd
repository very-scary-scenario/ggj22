extends Node2D

var bullet_colour_list = [Color.rebeccapurple, Color.burlywood, Color.aqua]
var bullet_type = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.modulate = bullet_colour_list[bullet_type]
	$AnimationPlayer.play("Animate")
	z_index = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func remove_item():
	get_parent().remove_child(self)

func remove_bullet():
	call_deferred("remove_item")
