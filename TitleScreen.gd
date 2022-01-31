extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var clicked =  false
var music = []
# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition.toggle_blanked(1)
	music.append(preload("res://Music/title_intro.mp3"))
	music.append(preload("res://Music/title_loop.mp3"))	
	$MusicPlayer.stream= music.front()
	$MusicPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if clicked and not $Transition.in_progress():
		get_tree().change_scene("res://TwinStickShooter/TwinStickShooter.tscn")
	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		if not clicked:
			$Transition.toggle_blanked(1)
			clicked = true


func _on_MusicPlayer_finished():
	$MusicPlayer.stream = music[1]
	$MusicPlayer.play()
