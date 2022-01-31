extends Node2D
export var intro_text_timer = 240

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state = 0

var cutscene_1 = false
var cutscene_2 = false
var cutscene_3 = false
var cutscene_ticker = 0
var cutscene_length = 180

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		0:
			intro_text_timer -= 1
			if intro_text_timer == 0:
				state = 1
				$IntroScreen/groupnode.visible = false
				$HeroParty.paused = false
		2:
			if not $BattleScene.battle_in_progress:
				$BattleScene.visible = false
				$HeroParty.paused = false
				state = 1
		99:
			cutscene_ticker += 1
			if cutscene_ticker == cutscene_length:
				$Cutscenes/CutsceneImage.visible = false
				$Cutscenes/TextLine1.visible = false
				$Cutscenes/TextLine2.visible = false
				$Cutscenes/TextLine3.visible = false
				$HeroParty.paused = false
				state = 1
	pass


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
#		var area_temp = area.shape_owner_get_owner(area_shape_index)
#		print(area_temp.name)
		pass


func _on_Area2D_body_entered(body):
	if body.name == "HeroParty":
		body.paused = true
		$BattleScene.newBattle()
		$BattleScene.visible = true
		state = 2


func _on_CutsceneArea_area_shape_entered(_area_rid, area, area_shape_index, _local_shape_index):
#	print(area.name)
	pass


func _on_DuckArea_body_entered(body):
	if cutscene_1 == false:
		if body.name == "HeroParty":
			cutscene_1 = true
			$Cutscenes/CutsceneImage.frame = 1
			$Cutscenes/TextLine1.text_display = "A DUCK HAS JOINED YOUR"
			$Cutscenes/TextLine2.text_display = "PARTY. QUACKERS!"
			$Cutscenes/TextLine3.text_display = " "
			cutscene_ticker = 0
			body.paused = true
			state = 99
			$Cutscenes/CutsceneImage.visible = true
			$Cutscenes/TextLine1.visible = true
			$Cutscenes/TextLine2.visible = true
			$Cutscenes/TextLine3.visible = true
	pass # Replace with function body.

func _on_RoboArea_body_entered(body):
	if cutscene_2 == false:
		if body.name == "HeroParty":
			cutscene_2 = true
			$Cutscenes/CutsceneImage.frame = 2
			$Cutscenes/TextLine1.text_display = "ROBOMAGE HAS JOINED"
			$Cutscenes/TextLine2.text_display = "YOUR PARTY..."
			$Cutscenes/TextLine3.text_display = "RELUCTANTLY"
			cutscene_ticker = 0
			body.paused = true
			state = 99
			$Cutscenes/CutsceneImage.visible = true
			$Cutscenes/TextLine1.visible = true
			$Cutscenes/TextLine2.visible = true
			$Cutscenes/TextLine3.visible = true

func _on_CutsceneArea_body_entered(body):
		if body.name == "HeroParty":
			$Cutscenes/CutsceneImage.frame = 0
			$Cutscenes/TextLine1.text_display = "YOU STAYED AT THE INN."
			$Cutscenes/TextLine2.text_display = ""
			$Cutscenes/TextLine3.text_display = "YOU RECOVERED SOME HP!"
			cutscene_ticker = 0
			body.paused = true
			state = 99
			if get_tree().get_nodes_in_group("player_character").size() > 0:
				get_tree().get_nodes_in_group("player_character")[0].heal_player()		
			$Cutscenes/CutsceneImage.visible = true
			$Cutscenes/TextLine1.visible = true
			$Cutscenes/TextLine2.visible = true
			$Cutscenes/TextLine3.visible = true


func _on_TowerArea_body_entered(body):
		if body.name == "HeroParty":
			$Cutscenes/CutsceneImage.frame = 3
			$Cutscenes/TextLine1.text_display = "FOUND A TOWER."
			$Cutscenes/TextLine2.text_display = "NO MONSTERS, BUT YOU"
			$Cutscenes/TextLine3.text_display = "FOUND A BOMB!!!"
			cutscene_ticker = 0
			body.paused = true
			state = 99
			if get_tree().get_nodes_in_group("player_character").size() > 0:
				get_tree().get_nodes_in_group("player_character")[0].give_bomb()		
			$Cutscenes/CutsceneImage.visible = true
			$Cutscenes/TextLine1.visible = true
			$Cutscenes/TextLine2.visible = true
			$Cutscenes/TextLine3.visible = true


func _on_OasisArea_body_entered(body):
		if body.name == "HeroParty":
			$Cutscenes/CutsceneImage.frame = 4
			$Cutscenes/TextLine1.text_display = "ROBOMAGE IS HAPPY TO"
			$Cutscenes/TextLine2.text_display = "HAVE REACHED OASIS."
			$Cutscenes/TextLine3.text_display = "ROBOMAGE HATE SAND"
			cutscene_ticker = 0
			body.paused = true
			state = 99	
			$Cutscenes/CutsceneImage.visible = true
			$Cutscenes/TextLine1.visible = true
			$Cutscenes/TextLine2.visible = true
			$Cutscenes/TextLine3.visible = true


func _on_ShopArea_body_entered(body):
		if body.name == "HeroParty":
			$Cutscenes/CutsceneImage.frame = 5
			$Cutscenes/TextLine1.text_display = "VISITED THE SHOP."
			$Cutscenes/TextLine2.text_display = "NO POTIONS, BUT THEY"
			$Cutscenes/TextLine3.text_display = "HAD A LOT OF BOMBS!"
			cutscene_ticker = 0
			body.paused = true
			state = 99
			if get_tree().get_nodes_in_group("player_character").size() > 0:
				get_tree().get_nodes_in_group("player_character")[0].give_bomb()		
				get_tree().get_nodes_in_group("player_character")[0].give_bomb()					
			$Cutscenes/CutsceneImage.visible = true
			$Cutscenes/TextLine1.visible = true
			$Cutscenes/TextLine2.visible = true
			$Cutscenes/TextLine3.visible = true


func _on_CastleArea_body_entered(body):
		if body.name == "HeroParty":
			$Cutscenes/CutsceneImage.frame = 6
			if cutscene_3 == false:                           
				$Cutscenes/TextLine1.text_display = "YOU THINK THIS MIGHT"
				$Cutscenes/TextLine2.text_display = "BE THE WRONG CASTLE."
				$Cutscenes/TextLine3.text_display = "BEST GO AND CHECK..."
			else:
				$Cutscenes/TextLine1.text_display = "YOU STILL THINK THIS"
				$Cutscenes/TextLine2.text_display = "MIGHT NOT BE THE    "
				$Cutscenes/TextLine3.text_display = "CASTLE. WRONG TURN? "
			cutscene_3 = true
			cutscene_ticker = 0
			body.paused = true
			state = 99
			
			$Cutscenes/CutsceneImage.visible = true
			$Cutscenes/TextLine1.visible = true
			$Cutscenes/TextLine2.visible = true
			$Cutscenes/TextLine3.visible = true
