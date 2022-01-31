extends Node2D
const ImpactInst = preload("res://TwinStickShooter/BulletTypes/BulletImpact.tscn")
const ExplosionInst = preload("res://TwinStickShooter/BulletTypes/Explosion.tscn")

export var speed = 60
export var life_ticker = 40
var velocity = Vector2(0,0)
var bullet_type = 0
var dead = false
var exploded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	global_position += velocity
	life_ticker -= 1
	if life_ticker == 0:
		if bullet_type == 3:
			generate_explosion()
		call_deferred("remove_item")
	
func remove_item():
	if not dead:
		get_parent().remove_child(self)
		dead = true


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var area_temp = area.shape_owner_get_owner(area_shape_index)
	if area_temp.name in ["MonsterShape", "MonsterShape1", "MonsterShape2", "MonsterShape3"]:
#		print("BOOM!")
		if bullet_type in [0, 1, 2]:
			if get_tree().get_nodes_in_group("ImpactGrouping").size() > 0:
				var node = ImpactInst.instance()
				#get_tree().get_root().add_child(node)
				get_tree().get_nodes_in_group("ImpactGrouping")[0].add_child(node)
				node.global_position = global_position
				node.bullet_type = bullet_type
				node.modulate = node.bullet_colour_list[bullet_type]
		else:
			generate_explosion()
			
		if area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().spawning == false:
			if bullet_type in [0, 1, 2, 3]:
				call_deferred("remove_item")
				area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().got_hit()			

func generate_explosion():
	if exploded == false:
		if get_tree().get_nodes_in_group("ImpactGrouping").size() > 0:
			var node = ExplosionInst.instance()
			#get_tree().get_root().add_child(node)
			get_tree().get_nodes_in_group("ImpactGrouping")[0].add_child(node)
			node.global_position = global_position
			node.z_index = 3
			exploded = true
