extends Node2D
var paused = true

var velocity = Vector2(0, -1)
var in_reverse = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("hero_party")
	$HeroASprite/AnimationPlayer.play("WalkUp")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	#print(paused)
	if not paused:
#		global_position.y -= 1
		global_position += velocity
#		if global_position.y == -1472:
#			global_position.y = -128
		#print(global_position.y)


func _on_BounceDetector_area_shape_entered(_area_rid, area, area_shape_index, _local_shape_index):
	var area_temp = area.shape_owner_get_owner(area_shape_index)
	if area_temp.name == "BounceShape":
		match area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().direction:
			0:
				velocity = Vector2(0, -1)
				$HeroASprite/AnimationPlayer.play("WalkUp")
			1:
				velocity = Vector2(1, 0)
				$HeroASprite/AnimationPlayer.play("WalkRight")
			2:
				velocity = Vector2(0, 1)
				$HeroASprite/AnimationPlayer.play("WalkDown")
			3:
				velocity = Vector2(-1, 0)
				$HeroASprite/AnimationPlayer.play("WalkLeft")
