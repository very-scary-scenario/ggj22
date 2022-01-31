extends Node2D
const Monster1Inst = preload("res://TwinStickShooter/Monsters/Monster1.tscn")
const SummonInst = preload("res://TwinStickShooter/Monsters/SummonCircle.tscn")
export var SpawnPoint1 = Vector2(-128,-128)
export var SpawnPoint2 = Vector2(1120,798)
var wave = 0
var rng = RandomNumberGenerator.new()
var permitted_summons = 1
var permitted_monsters = 10
var monsters_killed = 0
var score = 0
var trigger_death_music = false
export var spawning_off = false

var reset_ticker = 0
var reset_limit = 1200
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var music = []

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	add_to_group("TwinStickMain")
	$UINode/AmmoLabel.add_to_group("ammo_label")
	$UINode/HealthLabel.add_to_group("health_label")
	$PowerUpGrouping.add_to_group("PowerUpGrouping")
	$BulletGrouping.add_to_group("BulletGrouping")
	$BloodSplatGrouping.add_to_group("BloodGrouping")
	$MonsterGrouping.add_to_group("MonsterGrouping")
	$ImapctGrouping.add_to_group("ImpactGrouping")
	
	music.append(preload("res://Music/intro.mp3"))
	music.append(preload("res://Music/loop.mp3"))
	music.append(preload("res://Music/GAMEOVER.mp3"))
	$MusicPlayer.stream= music.front()
	$MusicPlayer.play()
	
#	print($SpawnArea/SpawnShape.global_position, " ", $SpawnArea/SpawnShape.shape.extents)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	if get_tree().get_nodes_in_group("monster").size() < permitted_monsters:
		if get_tree().get_nodes_in_group("SUMMONCIRCLES").size() < permitted_summons:
			spawn_a_summon_circle(rng.randi_range(SpawnPoint1.x, SpawnPoint2.x),rng.randi_range(SpawnPoint1.y, SpawnPoint2.y))			
#		spawn_a_monster(rng.randi_range(SpawnPoint1.x, SpawnPoint2.x),rng.randi_range(SpawnPoint1.y, SpawnPoint2.y))
		
	if get_tree().get_nodes_in_group("PLAYER_DEAD").size() > 0:
		if trigger_death_music == false:
			$MusicPlayer.stream = music[2]
			$MusicPlayer.play()
			trigger_death_music = true
		
		if $DeadLayer/ColorRect.visible == false:
			$DeadLayer/ColorRect.visible = true
			$DeadLayer/DeadLabel.visible = true
			$DeadLayer/DeadScoreLabel.text_display = "FINAL SCORE:" + str(score)
			$DeadLayer/DeadScoreLabel.visible = true
#		if $DeadLayer/ColorRect.modulate.a < 1.5:
		$DeadLayer/ColorRect.color.a += 0.2
		if $DeadLayer/ColorRect.color.a >= 1:
			$DeadLayer/ColorRect.color.a = 1
			reset_ticker += 1
			if reset_ticker == reset_limit:
				var dump = get_tree().change_scene("res://TitleScreen.tscn")
	
	if get_tree().get_nodes_in_group("hero_party").size() > 0:
		$UINode/ViewportContainer/Viewport/Camera2D.position = get_tree().get_nodes_in_group("hero_party")[0].position + Vector2(772, 40)
#		print($UINode/ViewportContainer/Viewport/Camera2D.position)
	
	if $Player.current_bombs > 0:
		$UINode/BombLabel.visible = true
		$UINode/BombLabel.text_display = "BOMBS:" + str($Player.current_bombs)
	else:
		$UINode/BombLabel.visible = false
	
	$UINode/ScoreLabel.text_display = "SCORE:" + str(score)
	check_wave()
#	score += 1
#	print(score)

func check_wave():
	match wave:
		0:
			if monsters_killed > 40:
				wave += 1
				permitted_summons += 1
				permitted_monsters += 5
		1:
			if monsters_killed > 80:
				permitted_monsters += 5
				wave += 1
		2:
			if monsters_killed > 120:
				permitted_summons += 1
				permitted_monsters += 5
				wave += 1
		3:
			if monsters_killed > 140:
				permitted_monsters += 10
				wave += 1
		4:
			if monsters_killed > 180:
				wave += 1
		5:
			if monsters_killed > 250:
				wave += 1
				
	
func spawn_a_monster(spawn_x, spawn_y):
		var node = Monster1Inst.instance()
		$MonsterGrouping.add_child(node)
		node.global_position = Vector2(spawn_x, spawn_y)
	
func spawn_a_summon_circle(spawn_x, spawn_y):
	if not spawning_off:
		var node = SummonInst.instance()
		$SummonGrouping.add_child(node)
		node.global_position = Vector2(spawn_x, spawn_y)
		node.summon_type = rng.randi_range(0, wave)

func add_to_score(points):
	score += points


func _on_MusicPlayer_finished():
	if get_tree().get_nodes_in_group("PLAYER_DEAD").size() == 0:
		$MusicPlayer.stream = music[1]
		$MusicPlayer.play()
