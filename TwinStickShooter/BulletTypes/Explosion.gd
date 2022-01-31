extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Animate")
	pass # Replace with function body.


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var area_temp = area.shape_owner_get_owner(area_shape_index)
	if area_temp.name in ["MonsterShape", "MonsterShape1", "MonsterShape2", "MonsterShape3"]:
#		print("BOOM!")
		if area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().spawning == false:
			area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().got_hit()		

func explosion_end():
	call_deferred("remove_item")

func remove_item():
	get_parent().remove_child(self)
