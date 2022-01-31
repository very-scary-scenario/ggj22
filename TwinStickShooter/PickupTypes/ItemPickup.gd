extends Node2D
export var pickup_type = 2
var colour_list = [Color.rebeccapurple, Color.burlywood, Color.aqua]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	modulate = colour_list[pickup_type]
	$AnimationPlayer.play("Animate")
	$Sprite.frame = pickup_type
	
func _physics_process(_delta):
#	modulate = colour_list[pickup_type]	
	$Sprite.frame = pickup_type
	
func remove_item():
	get_parent().remove_child(self)

func contacted_player():
	call_deferred("remove_item")
