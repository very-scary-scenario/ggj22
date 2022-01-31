extends KinematicBody2D
const basic_bullet = preload("res://TwinStickShooter/BulletTypes/BasicBullet.tscn")
var rng = RandomNumberGenerator.new()

var bullet_colour_list = [Color.rebeccapurple, Color.burlywood, Color.aqua, Color.crimson]
var bullet_speed_list = [10, 8, 20, 8]
var bullet_life_list = [60, 30, 40, 50]
var fire_speed_list = [5, 10, 3, 10]
var bullet_ammo_list = [0, 120, 120, 50]

export var movement_speed = 200

export var fire_speed = 5
export var bullet_speed = 10
export var max_hp = 10
export var current_hp = 10

var movement_speed_diag = 0

var current_weapon = 0
var current_ammo = 0
var velocity = Vector2(0,0)

var paused = 0
var fire_ticker = 0

var mouse_clicked = false

var num_spread = 10
var spread_angles = [0]

var current_state = 0
var current_bombs = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
#	movement_speed_diag = sqrt((movement_speed * movement_speed) + (movement_speed * movement_speed))
	movement_speed_diag = sin(deg2rad(45)) * movement_speed
#	print (movement_speed, " ", movement_speed_diag)
	add_to_group("player_character")
	
	for i in range(1, num_spread * 2):
		var num = float(i) / 10
		spread_angles.append(num)
		spread_angles.append(num * -1)
	
	pass # Replace with function body.

func _physics_process(_delta):
	if current_state == 0:
		alive_play()
	
	if current_ammo > 0:
		get_tree().get_nodes_in_group("ammo_label")[0].text_display = "AMMO:" + str(current_ammo)

	get_tree().get_nodes_in_group("health_label")[0].text_display = "HEALTH:" + str(current_hp)	
	
func alive_play():
	if fire_ticker > 0:
		fire_ticker -= 1
	
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var bomb = Input.is_action_just_pressed("key_bomb_button")
	
	var dir_x = int(right) - int(left)
	var dir_y = int(down) - int(up)
	
	if dir_y == 0:
		velocity.y = 0
		velocity.x = dir_x * movement_speed
	else:
		if dir_x == 0:
			velocity.x = 0
			velocity.y = dir_y * movement_speed
		else:
			velocity.x = dir_x * movement_speed_diag
			velocity.y = dir_y * movement_speed_diag
		
	var check_vol = move_and_slide_with_snap (velocity, Vector2.ZERO)
	look_at(get_global_mouse_position())
	if mouse_clicked and fire_ticker == 0:
		spawn_bullet()
	
	if bomb:
		if current_bombs > 0:
			current_bombs -= 1
			get_tree().get_nodes_in_group("TwinStickMain")[0].score += get_tree().get_nodes_in_group("monster").size()
			for m in get_tree().get_nodes_in_group("monster"):
				m.player_collide()
	
#	if Input.is_action_just_pressed("ui_end"):
#		current_bombs += 1
	
	
func spawn_bullet():
	if current_weapon == 1:
		spawn_spread()
	else:
		
		var nv = global_position - get_global_mouse_position()
		var bullet_velocity = nv.normalized() * - bullet_speed_list[current_weapon]
		var ang = velocity.angle()
		
		var node = basic_bullet.instance()
		#get_tree().get_root().add_child(node)
		get_tree().get_nodes_in_group("BulletGrouping")[0].add_child(node)
		node.modulate = bullet_colour_list[current_weapon]
		node.global_position = global_position
		node.velocity = bullet_velocity
		node.life_ticker = bullet_life_list[current_weapon]
		node.bullet_type = current_weapon
	fire_ticker = fire_speed_list[current_weapon]
	current_ammo -= 1
	if current_ammo <= 0:
		current_ammo = 0
		current_weapon = 0
		get_tree().get_nodes_in_group("ammo_label")[0].visible = false
	pass

func spawn_spread():
	for i in range (num_spread):
		var node = basic_bullet.instance()
		var angle = get_angle_to(get_global_mouse_position())
		angle = get_global_mouse_position().angle_to_point(global_position)
#		print(angle)
		var nv = global_position - get_global_mouse_position()
		var bullet_velocity = nv.normalized() * - bullet_speed_list[current_weapon]
#		var angle = velocity.angle()

		angle += spread_angles[i]
		
		#get_tree().get_root().add_child(node)
		get_tree().get_nodes_in_group("BulletGrouping")[0].add_child(node)
		node.modulate = bullet_colour_list[current_weapon]
		node.global_position = global_position
		node.velocity.x = bullet_speed_list[current_weapon] * cos(angle)
		node.velocity.y = bullet_speed_list[current_weapon] * sin(angle)
		node.life_ticker = bullet_life_list[current_weapon]
		node.bullet_type = current_weapon
		
	pass

func _input(event):
   if event is InputEventMouseButton:
	   mouse_clicked = ! mouse_clicked



func _on_PickupChecker_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var area_temp = area.shape_owner_get_owner(area_shape_index)
	if area_temp.name == "ItemPlayerDetectShape":
		current_weapon = area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().pickup_type
		current_ammo = bullet_ammo_list[current_weapon]
		area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().contacted_player()
		get_tree().get_nodes_in_group("ammo_label")[0].text_display = "AMMO:" + str(current_ammo)
		get_tree().get_nodes_in_group("ammo_label")[0].visible = true
	elif area_temp.name in ["MonsterShape", "MonsterShape1", "MonsterShape2", "MonsterShape3", "MonsterShape4"] and current_state == 0:
		if not area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().spawning:
			area.shape_owner_get_owner(area_shape_index).get_parent().get_parent().player_collide()
			if area_temp.name == "MonsterShape3":
				current_hp -= 5
			else:
				current_hp -= 1
			$TakeDamage.play()
			$AnimationPlayer.play("TakeDamage")
			if current_hp < 0:
				current_hp = 0
			if current_hp == 0:
				visible = false
				add_to_group("PLAYER_DEAD")
				current_state = 99

func take_damage():
	$TakeDamage.play()
	$AnimationPlayer.play("TakeDamage")	
	if current_state < 99:
		if current_hp > 0:
			current_hp -= 1
		else:
			visible = false
			add_to_group("PLAYER_DEAD")
			current_state = 99			

func random_powerup():
	if (rng.randi_range(0, 100)) < 10:
		current_bombs += 1		
	else:
		var powerup_pick = rng.randi_range(1,3)
		current_weapon = powerup_pick
		current_ammo = bullet_ammo_list[powerup_pick]
		get_tree().get_nodes_in_group("ammo_label")[0].text_display = "AMMO:" + str(current_ammo)
		get_tree().get_nodes_in_group("ammo_label")[0].visible = true	

func heal_player():
	current_hp += 3
	if current_hp > max_hp:
		current_hp = max_hp
	
func give_bomb():
	current_bombs += 1
