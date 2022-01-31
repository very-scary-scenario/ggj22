extends Node2D
export var TextFile = ""

var openingLines = []
var attackLines = []
var successLines = []
var failLines = []
var winLines = []
var awardLines = []
var deadLines = []

var monster_index = 0

var battle_state = 0
var battle_running = false

var splash_length = 120
var pause_length = 30
var attack_delay_length = 60
var new_attack_delay = 120
var splash_ticker = 0

var attack_successful = 0

var battle_in_progress = false

var battle_timer = 20
var battle_timer_frames = 60
var battle_ticker = 0
var battle_ticker_frames = 0

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	var text_lines = read_file(TextFile)
	var value_type = 0
	var index = 0
	while index < text_lines.size():
		if text_lines[index].left(1) == "#":
			value_type += 1
		else:
			if text_lines[index].left(1) != " ":
				if text_lines[index].length() > 2:
					match value_type:
						1:
							openingLines.append(text_lines[index])
						2:
							attackLines.append(text_lines[index])
						3:
							successLines.append(text_lines[index])
						4:
							failLines.append(text_lines[index])
						5:
							winLines.append(text_lines[index])
						6:
							awardLines.append(text_lines[index])
						7:
							deadLines.append(text_lines[index])
		index += 1
	pass
	splash_ticker = 0
	add_to_group("BATTLE_SCENE")
#	print($MonsterDictionary.RPGMonsterList.size())
#	newBattle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if battle_in_progress:
		battle_processing()
	
func battle_processing():
	match battle_state:
		0:
			splash_ticker += 1
			if splash_ticker >= splash_length:
				battle_state = 1
				$TextSplash/TextGrouping.visible = false
				splash_ticker = 0
		1:
			splash_ticker += 1
			if splash_ticker == pause_length:
				battle_state = 2
				display_battle_string(attackLines[rng.randi_range(0, attackLines.size() - 1)])
				$BattleTextCanvas/BattleTextNode.visible = true
				#$TypingWord.word_to_type = $MonsterDictionary.RPGMonsterList[monster_index].WordList[rng.randi_range(0, $MonsterDictionary.RPGMonsterList[monster_index].WordList.size() - 1)]
				$BattleLayer/TypingWord.reset_word( $MonsterDictionary.RPGMonsterList[monster_index].WordList[rng.randi_range(0, $MonsterDictionary.RPGMonsterList[monster_index].WordList.size() - 1)])
				splash_ticker = 0
		2:
			splash_ticker += 1
			if splash_ticker == attack_delay_length:
				splash_ticker = 0
				battle_state = 3
				$BattleLayer/TypingWord.visible = true
				$BattleLayer/TypingWord.word_active = true
				$BattleLayer/TimerLabel.visible = true
				$BattleLayer/TimerLabel/TimerValue.text_display = str(battle_timer - battle_ticker)
				attack_successful = 0
				battle_ticker_frames = 0
				battle_ticker = 0
		3:
			battle_ticker_frames += 1
			if battle_ticker_frames == battle_timer_frames:
				battle_ticker_frames = 0
				battle_ticker += 1
				$BattleLayer/TimerLabel/TimerValue.text_display = str(battle_timer - battle_ticker)				
				if battle_ticker == battle_timer:
					$BattleLayer/TypingWord.visible = false
					$BattleLayer/TimerLabel.visible = false
					battle_ticker = 0
					$BattleLayer/TimerLabel/TimerValue.text_display = str(battle_timer - battle_ticker)				
					attack_successful = 2
			
			if attack_successful > 0:
				if attack_successful == 1:
					display_battle_string(successLines[rng.randi_range(0, successLines.size() - 1)])
					battle_state = 5
					$BattleLayer/TimerLabel.visible = false
				else:
					display_battle_string(failLines[rng.randi_range(0, failLines.size() - 1)])
					if get_tree().get_nodes_in_group("player_character").size() > 0:
						get_tree().get_nodes_in_group("player_character")[0].take_damage()
					splash_ticker = 0
					battle_state = 4
					$BattleLayer/TimerLabel.visible = false
		4:
			splash_ticker += 1
			if splash_ticker == new_attack_delay:
				splash_ticker = 0
				battle_state = 1
		5:
			splash_ticker += 1
			if splash_ticker == new_attack_delay:
				splash_ticker = 0
				battle_state = 6
		6:
			if get_tree().get_nodes_in_group("BATTLEMONSTER").size() > 0:
				get_tree().get_nodes_in_group("BATTLEMONSTER")[0].modulate.a -= 0.1
				if get_tree().get_nodes_in_group("BATTLEMONSTER")[0].modulate.a <= 0:
					battle_state = 7
#					get_tree().get_nodes_in_group("BATTLEMONSTER")[0].remove_from_group("BATTLEMONSTER")
			else:
				battle_state = 7
		7:
			display_splash_string (winLines[rng.randi_range(0, winLines.size() - 1)] + " " + awardLines[rng.randi_range(0, awardLines.size() - 1)])
			battle_state = 8
			splash_ticker = 0
		8:
			splash_ticker += 1
			if splash_ticker == splash_length:
				battle_state = 9
		9:
			battle_in_progress = false
			$BattleTextCanvas/BattleTextNode.visible = false
			$TextSplash/TextGrouping.visible = false
			if get_tree().get_nodes_in_group("player_character").size() > 0:
				get_tree().get_nodes_in_group("player_character")[0].random_powerup()		
			if get_tree().get_nodes_in_group("BATTLEMONSTER").size() > 0:
				get_tree().get_nodes_in_group("BATTLEMONSTER")[0].modulate.a = 1
				$BattleLayer/MonsterNode.remove_child(get_tree().get_nodes_in_group("BATTLEMONSTER")[0])
#				print($MonsterDictionary.RPGMonsterList.size())
#				get_tree().get_nodes_in_group("BATTLEMONSTER")[0].remove_from_group("BATTLEMONSTER")

	pass

func newBattle():
	battle_state = 0
	monster_index = rng.randi_range(0, $MonsterDictionary.RPGMonsterList.size() - 1)
	display_splash_string(openingLines[rng.randi_range(0, openingLines.size() - 1)])
	$BattleTextCanvas/BattleTextNode.visible = false
	$TextSplash/TextGrouping.visible = true
	var GrabbedInstance = $MonsterDictionary.RPGMonsterList[monster_index]
	GrabbedInstance.add_to_group("BATTLEMONSTER")
	$BattleLayer/MonsterNode.add_child(GrabbedInstance)
	splash_ticker = 0
	battle_in_progress = true
	pass


func display_splash_string(new_text):
	new_text = new_text.to_upper()
	#print (monster_index)
	new_text = new_text.replace("<ENEMY>", $MonsterDictionary.RPGMonsterList[monster_index].name.to_upper())
	$TextSplash/TextGrouping/TextLine1.text_display = ""
	$TextSplash/TextGrouping/TextLine2.text_display = ""
	$TextSplash/TextGrouping/TextLine3.text_display = ""
	
	var new_words = new_text.split(" ")
	var curr_line = 1
	var curr_line_string = ""
	for word in new_words:
		if curr_line_string.length() + word.length() >= 22:
			match curr_line:
				1:
					$TextSplash/TextGrouping/TextLine1.text_display = curr_line_string
				2:
					$TextSplash/TextGrouping/TextLine2.text_display = curr_line_string
				3:
					$TextSplash/TextGrouping/TextLine3.text_display = curr_line_string
			curr_line += 1
			curr_line_string = word + " "
		else:
			curr_line_string = curr_line_string + word + " "
		match curr_line:
			1:
				$TextSplash/TextGrouping/TextLine1.text_display = curr_line_string
			2:
				$TextSplash/TextGrouping/TextLine2.text_display = curr_line_string
			3:
				$TextSplash/TextGrouping/TextLine3.text_display = curr_line_string
				
func display_battle_string(new_text):
	new_text = new_text.to_upper()
#	print (monster_index)
	new_text = new_text.replace("<ENEMY>", $MonsterDictionary.RPGMonsterList[monster_index].name.to_upper())
	$BattleTextCanvas/BattleTextNode/TextLine1.text_display = ""
	$BattleTextCanvas/BattleTextNode/TextLine2.text_display = ""
	$BattleTextCanvas/BattleTextNode/TextLine3.text_display = ""
	
	var new_words = new_text.split(" ")
	var curr_line = 1
	var curr_line_string = ""
	for word in new_words:
		if curr_line_string.length() + word.length() >= 22:
			match curr_line:
				1:
					$BattleTextCanvas/BattleTextNode/TextLine1.text_display = curr_line_string
				2:
					$BattleTextCanvas/BattleTextNode/TextLine2.text_display = curr_line_string
				3:
					$BattleTextCanvas/BattleTextNode/TextLine3.text_display = curr_line_string
			curr_line += 1
			curr_line_string = word + " "
		else:
			curr_line_string = curr_line_string + word + " "
		match curr_line:
			1:
				$BattleTextCanvas/BattleTextNode/TextLine1.text_display = curr_line_string
			2:
				$BattleTextCanvas/BattleTextNode/TextLine2.text_display = curr_line_string
			3:
				$BattleTextCanvas/BattleTextNode/TextLine3.text_display = curr_line_string

func read_file(file):
	var text_lines = []
	var f = File.new()
	f.open(file, File.READ)
#	var index = 1
	while not f.eof_reached():
		var line = f.get_line()
		text_lines.append(line)
	f.close()
	return text_lines
	
