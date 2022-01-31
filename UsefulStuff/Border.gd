extends Node2D

export var initial_colour = Color(0.0, 0.0, 0.0)
export var flash_length = 10
export var switch_length = 2
var state = 0

var flash_colour = [Color(1, 0, 0), Color(0, 1, 0), Color (0, 0, 1), Color (1, 1, 0), Color(1, 1, 1)]
var length_pointer = 0
var flash_ticker = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.modulate = initial_colour
	pass # Replace with function body.


func _process(_delta):
	if state == 1:		
		flash_ticker += 1
		if flash_ticker % switch_length == 0:
			length_pointer += 1
			if length_pointer == flash_length:
				state = 0
				$Sprite.modulate = initial_colour
				flash_ticker = 0
				length_pointer = 0
			else:
				$Sprite.modulate = (flash_colour[length_pointer % flash_colour.size()])
			
func start_flash():
	state = 1
