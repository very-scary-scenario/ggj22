extends Node2D
const PowerupInst = preload("res://TwinStickShooter/PickupTypes/ItemPickup.tscn")
const BloodSplatInst = preload("res://TwinStickShooter/Monsters/BloodSplat.tscn")
const DeathPlayInst = preload("res://TwinStickShooter/Monsters/DeathSoundPlayer.tscn")
#export var speed = 1.5
export var speed = 5
export var health = 3
export var powerup_chance = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dead = false
var rng = RandomNumberGenerator.new()
var bloodsplats = 30

var spawning = true
var spawning_ticker = 0.0
var spawning_increment = 0.01
var velocity = Vector2(0,0)
var direction_set = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("monster")
	rng.randomize()
	rotation_degrees = rng.randi_range(0, 360)
	modulate = Color(0.0, 0.0, 0.0, 0.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	if spawning:
		spawning_ticker += spawning_increment
		modulate = Color(spawning_ticker, spawning_ticker, spawning_ticker, spawning_ticker)	
		if spawning_ticker >= 1.0:
			modulate = Color(1.0, 1.0, 1.0, 1.0)	
			spawning = false
	else:
		var playerList = get_tree().get_nodes_in_group("player_character")
		if playerList.size() > 0:
			if not direction_set:
#				var velocity = Vector2(0,0)
				var nv = global_position - playerList[0].global_position
				velocity = nv.normalized() * - speed
		#		var ang = velocity.angle()
				global_position += velocity
				#look_at(playerList[0].global_position)
				look_at(global_position + velocity)
				direction_set = true
			else:
				global_position += velocity
				look_at(global_position + velocity)				
		
func got_hit():
	if spawning == false:
		health -= 1
		if health == 0:
			if not dead:
				generate_blood_splats()
				var pu_check = rng.randi_range(0, 100)
				#$DeathSound.play()
		#		print (pu_check)
				if pu_check < powerup_chance:
					var node = PowerupInst.instance()
					get_tree().get_nodes_in_group("PowerUpGrouping")[0].add_child(node)
					node.global_position = global_position
					node.pickup_type = rng.randi_range(1,2)
				
				var ds_node = DeathPlayInst.instance()
				get_tree().get_nodes_in_group("MonsterGrouping")[0].add_child(ds_node)
				ds_node.global_position = global_position
								
				get_tree().get_nodes_in_group("TwinStickMain")[0].add_to_score(5)
				if not dead:
					dead = true
					call_deferred("remove_item")

func player_collide():
	if not dead:
		var ds_node = DeathPlayInst.instance()
		get_tree().get_nodes_in_group("MonsterGrouping")[0].add_child(ds_node)
		ds_node.global_position = global_position		
		dead = true
		generate_blood_splats()
		call_deferred("remove_item")


func remove_item():
		get_tree().get_nodes_in_group("TwinStickMain")[0].monsters_killed += 1		
		get_parent().remove_child(self)		
		dead = true

		
func generate_blood_splats():
	for _i in range(bloodsplats):
		var node = BloodSplatInst.instance()
		get_tree().get_nodes_in_group("BloodGrouping")[0].add_child(node)
		node.global_position = global_position
		node.velocity = Vector2(rng.randf_range(-2.0, 2.0), rng.randf_range(-2.0, 2.0))
		node.fade_speed = rng.randf_range(0.01, 0.2)
		node.random_frame(rng.randi_range(0, 15))


func _on_MonsterArea_area_shape_entered(_area_rid, area, area_shape_index, _local_shape_index):
	var area_temp = area.shape_owner_get_owner(area_shape_index)
#	print(area_temp.name)
	if area_temp.name == "bounceshapey":
		velocity.y = - velocity.y
	elif area_temp.name == "bounceshapex":
		velocity.x = - velocity.x
	pass # Replace with function body.
