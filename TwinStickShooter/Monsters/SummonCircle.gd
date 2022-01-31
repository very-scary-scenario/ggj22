extends Node2D
const Monster1Inst = preload("res://TwinStickShooter/Monsters/Monster1.tscn")
const Monster2Inst = preload("res://TwinStickShooter/Monsters/Monster2.tscn")
const Monster3Inst = preload("res://TwinStickShooter/Monsters/Monster3.tscn")
const Monster4Inst = preload("res://TwinStickShooter/Monsters/Monster4.tscn")
var angle = 0
var state = 0
var fade_value = 0.0
var fade_speed = 0.01
var summon_type = 0
var wave = 0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("SUMMONCIRCLES")
	rng.randomize()
	angle = rng.randi_range(0, 360)
	rotation_degrees = angle
	modulate = Color(fade_value, fade_value, fade_value, fade_value)
	pass
	
func _physics_process(_delta):
	#print(state)
	if state == 0:
		angle += 0.2
		fade_value += fade_speed
		if fade_value >= 1.0:
			fade_value = 1.0
			state = 1
			do_summoning()
		modulate = Color(fade_value, fade_value, fade_value, fade_value)
		rotation_degrees = angle
	else:
		angle += 0.2
		fade_value -= fade_speed
		modulate = Color(fade_value, fade_value, fade_value, fade_value)
		rotation_degrees = angle
		if fade_value <= 0:
			fade_value = 0
			state = 2
			call_deferred("remove_item")
		
func do_summoning():
#	summon_type = 6
	var SpawnArea = $Sprite.get_rect()
	var SpawnPos = global_position
	SpawnPos.x -= SpawnArea.size.x / 2
	SpawnPos.y -= SpawnArea.size.y / 2
#	print($Sprite.global_position, " ", $Sprite.get_rect())
	match summon_type:
		0:
			for _i in range(0, 10):
				#spawn_a_monster(rng.randi_range(SpawnArea.position.x, SpawnArea.position.x + SpawnArea.size.x),rng.randi_range(SpawnArea.position.y, SpawnArea.position.y + SpawnArea.size.y))
				spawn_a_monster(rng.randi_range(SpawnPos.x, SpawnPos.x + SpawnArea.size.x),rng.randi_range(SpawnPos.y, SpawnPos.y + SpawnArea.size.y), 1)
		1:
			for _i in range(0, 20):
				spawn_a_monster(rng.randi_range(SpawnPos.x, SpawnPos.x + SpawnArea.size.x),rng.randi_range(SpawnPos.y, SpawnPos.y + SpawnArea.size.y), 1)
		2:
			for _i in range(0, 5):
				spawn_a_monster(rng.randi_range(SpawnPos.x, SpawnPos.x + SpawnArea.size.x),rng.randi_range(SpawnPos.y, SpawnPos.y + SpawnArea.size.y), 2)
		3:
			for _i in range(0, 10):
				spawn_a_monster(rng.randi_range(SpawnPos.x, SpawnPos.x + SpawnArea.size.x),rng.randi_range(SpawnPos.y, SpawnPos.y + SpawnArea.size.y), 2)
		4:
			spawn_a_monster(rng.randi_range(SpawnPos.x, SpawnPos.x + SpawnArea.size.x),rng.randi_range(SpawnPos.y, SpawnPos.y + SpawnArea.size.y), 3)
		5:
			for _i in range(0, 5):
				spawn_a_monster(rng.randi_range(SpawnPos.x, SpawnPos.x + SpawnArea.size.x),rng.randi_range(SpawnPos.y, SpawnPos.y + SpawnArea.size.y), 1)
			spawn_a_monster(rng.randi_range(SpawnPos.x, SpawnPos.x + SpawnArea.size.x),rng.randi_range(SpawnPos.y, SpawnPos.y + SpawnArea.size.y), 3)
		6:
			for _i in range(0,3):
				spawn_a_monster(rng.randi_range(SpawnPos.x, SpawnPos.x + SpawnArea.size.x),rng.randi_range(SpawnPos.y, SpawnPos.y + SpawnArea.size.y), 4)			
				
func spawn_a_monster(spawn_x, spawn_y, spawn_type):
	match spawn_type:
		1:
			var node = Monster1Inst.instance()
			get_tree().get_nodes_in_group("MonsterGrouping")[0].add_child(node)
			node.global_position = Vector2(spawn_x, spawn_y)
		2:
			var node = Monster2Inst.instance()
			get_tree().get_nodes_in_group("MonsterGrouping")[0].add_child(node)
			node.global_position = Vector2(spawn_x, spawn_y)
		3:
			var node = Monster3Inst.instance()
			get_tree().get_nodes_in_group("MonsterGrouping")[0].add_child(node)
			node.global_position = Vector2(spawn_x, spawn_y)
		4:
			var node = Monster4Inst.instance()
			get_tree().get_nodes_in_group("MonsterGrouping")[0].add_child(node)
			node.global_position = Vector2(spawn_x, spawn_y)

func remove_item():
	get_parent().remove_child(self)		
