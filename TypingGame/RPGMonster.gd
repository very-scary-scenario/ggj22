extends Node2D

var Name = ""
var WordList = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_Texture(new_image):
	$MonsterImage.texture = new_image

#func remove_item():
#	if not dead:
#		get_parent().remove_child(self)		
#		dead = true
