extends Node
export (PackedScene) var RPGMonster

export var WordDirectory = ""
export var ImageDirectory = ""
var RPGMonsterList = []


# Called when the node enters the scene tree for the first time.
func _ready():
#	print("HERE")
	var MonsterFiles = list_files_in_directory(WordDirectory)
#	print(MonsterFiles)
	for monster_file in MonsterFiles:
#		print (monster_file)
		var monster_image = load(ImageDirectory + monster_file + ".png")
		#print(WordDirectory + monster_file + ".txt")
		var text_lines = read_file(WordDirectory + monster_file + ".txt")
		var new_RPGMonster = RPGMonster.instance()
		
		var index = 0
		while index < text_lines.size():
			if text_lines[index].length() > 2:
				new_RPGMonster.WordList.append(text_lines[index])
			index += 1
		new_RPGMonster.set_Texture(monster_image)
		new_RPGMonster.name = monster_file.replace("_", " " )
		#new_RPGMonster.name = monster_file
		RPGMonsterList.append(new_RPGMonster)
		
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
	
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			file = file.replace(".txt", "")
			files.append(file)
			
	dir.list_dir_end()
	return files
